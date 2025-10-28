############################################################
# lambda.tf - Versão segura para usar apenas tratamento INMET
# sem local-exec, sem leitura de layer/role bloqueados
############################################################

# compacta o código da lambda (arquivo deve existir em infra/terraform/lambda/)
data "archive_file" "lambda_inmet_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/tratamentoBaseINMET.py"
  output_path = "${path.module}/lambda/tratamentoBaseINMET.zip"
}

# Lambda única - tratamento INMET
resource "aws_lambda_function" "lambda_inmet" {
  function_name    = "handsync-tratamento-inmet"
  handler          = "tratamentoBaseINMET.lambda_handler"
  runtime          = "python3.9"

  # Role e Layer já existentes na AWS (sem precisar ler via Terraform)
  role             = "arn:aws:iam::278714589226:role/LabRole"

  filename         = data.archive_file.lambda_inmet_zip.output_path
  source_code_hash = data.archive_file.lambda_inmet_zip.output_base64sha256
  timeout          = 300

  # variáveis de ambiente para acessar buckets
  environment {
    variables = {
      RAW_BUCKET     = "handsync-raw-hs"
      TRUSTED_BUCKET = "handsync-trusted-hs"
    }
  }

  layers = [
    "arn:aws:lambda:us-east-1:278714589226:layer:handsync-python-layer-handsync:1"
  ]

  tags = {
    Name = "Lambda-HandsSync-INMET"
  }
}
