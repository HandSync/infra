# Compacta o primeiro arquivo Python
data "archive_file" "lambda_inmet_zip" {
  type        = "zip"
  source_file = "tratamentoBaseINMET.py"
  output_path = "tratamentoBaseINMET.zip"
}

# Compacta o segundo arquivo Python
data "archive_file" "lambda_assistidos_zip" {
  type        = "zip"
  source_file = "tratamentoBaseAssistidos.py"
  output_path = "tratamentoBaseAssistidos.zip"
}

# Usa o papel IAM já existente
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

# Lambda 1 – Tratamento INMET
resource "aws_lambda_function" "lambda_inmet" {
  function_name    = "handsync-tratamento-inmet"
  handler          = "tratamentoBaseINMET.lambda_handler"
  runtime          = "python3.9"
  role             = data.aws_iam_role.lab_role.arn
  filename         = data.archive_file.lambda_inmet_zip.output_path
  source_code_hash = data.archive_file.lambda_inmet_zip.output_base64sha256

  tags = {
    Name = "Lambda-HandsSync-INMET"
  }
}

# Lambda 2 – Tratamento Assistidos
resource "aws_lambda_function" "lambda_assistidos" {
  function_name    = "handsync-tratamento-assistidos"
  handler          = "tratamentoBaseAssistidos.lambda_handler"
  runtime          = "python3.9"
  role             = data.aws_iam_role.lab_role.arn
  filename         = data.archive_file.lambda_assistidos_zip.output_path
  source_code_hash = data.archive_file.lambda_assistidos_zip.output_base64sha256

  tags = {
    Name = "Lambda-HandsSync-Assistidos"
  }
}
