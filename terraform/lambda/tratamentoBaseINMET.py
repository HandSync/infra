import os
import boto3
import pandas as pd
import io

s3 = boto3.client("s3", region_name=os.environ.get("AWS_REGION"))

RAW_BUCKET = os.environ.get("RAW_BUCKET")
TRUSTED_BUCKET = os.environ.get("TRUSTED_BUCKET")

def upload_df_to_s3(df, bucket, key):
    """Faz upload de um DataFrame para S3 como Excel"""
    with io.BytesIO() as buffer:
        with pd.ExcelWriter(buffer, engine="openpyxl") as writer:
            df.to_excel(writer, index=False)
        buffer.seek(0)
        s3.put_object(Bucket=bucket, Key=key, Body=buffer.read())

def process_dataframe(df):
    """Processa os dados conforme sua lógica existente"""
    df.columns = [c.strip().upper() for c in df.columns]
    if "DESCARTAR" in df.columns:
        df = df.drop(columns=["DESCARTAR"], errors="ignore")

    if "DATA" in df.columns:
        df["DATA"] = pd.to_datetime(df["DATA"], errors="coerce")

    if "HORA_UTC" in df.columns:
        df["HORA_UTC"] = pd.to_datetime(df["HORA_UTC"], format="%H:%M", errors="coerce").dt.time

    num_cols = [c for c in df.columns if c not in ("DATA", "HORA_UTC")]
    for col in num_cols:
        try:
            df[col] = df[col].astype(str).str.replace(",", ".", regex=False).replace("-9999", "0")
            df[col] = pd.to_numeric(df[col], errors="coerce").fillna(0)
        except Exception:
            pass

    df_diario = df.groupby("DATA").agg({
        "PRECIPITACAO_MM": "sum",
        "TEMP_AR_C": ["mean", "max", "min"],
        "UMIDADE_RELATIVA": "mean",
        "VENTO_VELOCIDADE_MS": "mean"
    }).reset_index()

    df_diario.columns = [
        "DATA",
        "PRECIPITACAO_TOTAL_MM",
        "TEMP_MEDIA_C",
        "TEMP_MAXIMA_C",
        "TEMP_MINIMA_C",
        "UMIDADE_MEDIA",
        "VENTO_VELOCIDADE_MEDIA_MS"
    ]

    df_diario[df_diario.select_dtypes(include=["number"]).columns] = df_diario.select_dtypes(include=["number"]).round(2)

    return df_diario

def lambda_handler(event=None, context=None):
    """Roda localmente a partir das pastas ./RAW e ./trusted"""
    
    # Lista arquivos da pasta local ./RAW
    raw_files = [f for f in os.listdir("./RAW") if f.lower().endswith((".csv", ".xls", ".xlsx"))]
    if not raw_files:
        return {"statusCode": 200, "body": "Nenhum arquivo na pasta ./RAW."}

    dfs = []
    for f in raw_files:
        path = f"./RAW/{f}"
        try:
            if f.lower().endswith(".csv"):
                df = pd.read_csv(path, encoding="latin1", sep=";", skiprows=8)
            else:
                df = pd.read_excel(path)
            dfs.append(df)

            # Envia o arquivo original para o bucket RAW
            s3.upload_file(path, RAW_BUCKET, f)

        except Exception as e:
            print(f"Falha ao processar {f}: {e}")

    if not dfs:
        return {"statusCode": 200, "body": "Nenhum arquivo válido processado."}

    # Concatena e processa
    df_concat = pd.concat(dfs, ignore_index=True)
    df_result = process_dataframe(df_concat)

    # Salva resultado final no bucket TRUSTED
    key_out = "Base_Analise_INMET.xlsx"
    upload_df_to_s3(df_result, TRUSTED_BUCKET, key_out)

    return {"statusCode": 200, "body": f"Arquivos RAW enviados e base processada salva em s3://{TRUSTED_BUCKET}/{key_out}"}
