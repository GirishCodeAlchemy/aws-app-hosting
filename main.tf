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
