terraform {
  backend "gcs" {

    # This should align the repository name. This will create a folder in GCS for state.

    prefix = "backstage"
  }
}
