module "config" {
  source = "git@github.com:girish-devops-project/terraform-config.git"
}

module "lambda" {
  source = "git@github.com:girish-devops-project/terraform-lambda-module.git"

  for_each = module.config.lambda_configmap

  resource_name_prefix       = local.resource_name_prefix
  image_uri                  = try(each.value.image_uri, null)
  package_type               = try(each.value.package_type, "Image")
  vpc_id                     = each.value.vpc_id
  environment_variables      = try(each.value.environment_variables, null)
  lambda_name                = each.key
  lambda_handler             = each.value.lambda_handler
  lambda_description         = each.value.lambda_description
  managed_policy_arns        = each.value.managed_policy_arns
  lambda_has_inline_policy   = try(each.value.lambda_has_inline_policy, false)
  lambda_inline_policy       = try(each.value.lambda_inline_policy, null)
  schedule_time_trigger      = try(each.value.schedule_time_trigger, null)
  aws_lambda_permission      = try(each.value.aws_lambda_permission, [])
  lambda_assume_role_policy  = try(each.value.lambda_assume_role_policy, null)
  timeout                    = try(each.value.timeout, 3)
  memory_size                = try(each.value.memory_size, 128)
  source_path                = try(each.value.source_path, null)
  runtime                    = try(each.value.runtime, "python3.10")
  auto_update_function_image = try(each.value.auto_update_function_image, false)
  tags                       = try(each.value.tags, {})
  architectures              = try(each.value.architectures, ["x86_64"])
  sg_rules                   = try(each.value.sg_rules, [])
}

module "ec2" {

  source = "git@github.com:girish-devops-project/terraform-ec2-module.git"

  for_each = module.config.ec2_configmap

  resource_name_prefix = local.resource_name_prefix
  ami                  = each.value.ami
  instance_type        = each.value.instance_type
  key_name             = each.value.key_name
  subnet_id            = each.value.subnet_id
  vpc_id               = each.value.vpc_id
  ec2_name             = each.key
  sg_rules             = each.value.sg_rules
  user_data_path       = try(each.value.user_data_path, null)
  ebs_size             = try(each.value.ebs_size, null)
  root_volume_size     = try(each.value.root_volume_size, null)
}

module "api_gateway" {

  source = "git@github.com:girish-devops-project/terraform-apigateway-module.git"

  for_each = module.config.apigateway_configmap

  resource_name_prefix      = local.resource_name_prefix
  api_name                  = each.key
  managed_policy_arns       = each.value.managed_policy_arns
  api_gateway_inline_policy = try(each.value.api_gateway_inline_policy, null)
  uri                       = each.value.uri
  stage_name                = module.config.environment_config_map.environment
  request_parameters        = try(each.value.request_parameters, null)
  request_templates         = try(each.value.request_templates, null)
  passthrough_behavior      = each.value.passthrough_behavior

  depends_on = [module.lambda]

}


resource "aws_lambda_event_source_mapping" "event_trigger_lambda" {
  event_source_arn = module.api_gateway["app-dev-1x0-api-demo-api"].api_arn
  batch_size       = 1
  function_name    = "arn:aws:lambda:${local.region}:${local.account_id}:function:${local.resource_name_prefix}-lambda-demo-lambda" //module.lambda[0].arn
  depends_on       = [module.lambda]
}
