# Tests
# https://developer.hashicorp.com/terraform/language/tests

run "default" {
  assert {
    condition = module.test.prefix == "example"
    error_message = "Expected module.test.prefix to be 'example'"
  }

  command = apply

  module {
    source = "./tests/fixtures/default"
  }
}
