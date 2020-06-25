resource "null_resource" "helm_charts" {
  depends_on = ["module.eks", "module.vpc"]

  #triggers {
  #  cluster_endpoint = "${module.eks.cluster_endpoint}"
  #}

  provisioner "local-exec" {
    working_dir = "${path.module}"
    command     = "chmod u+x  ./scripts/install.sh"
  }

  provisioner "local-exec" {
    working_dir = "${path.module}"
    command     = "./scripts/install.sh"
    interpreter = ["/bin/sh", "-c"]

    environment {
      CLUSTER_NAME      = "${var.cluster_name}"
      CLUSTER_ZONE      = "${var.cluster_zone}"
      CLUSTER_ZONE_ID   = "${var.cluster_zone_id}"
      LETSENCRYPT_EMAIL = "${var.letsencrypt_email}"
      LETSENCRYPT_PRODUCTION = "${var.letsencrypt_production}"
      KUBECONFIG        = "${path.root}/kubeconfig_${var.cluster_name}"

    }
  }

  provisioner "local-exec" {
    working_dir = "${path.module}"
    when        = "destroy"
    command     = "chmod u+x  ./scripts/uninstall.sh"
  }

  provisioner "local-exec" {
    working_dir = "${path.module}"
    when        = "destroy"

    command     = "./scripts/uninstall.sh"
    interpreter = ["/bin/sh", "-c"]

    environment {
      KUBECONFIG      = "${path.root}/kubeconfig_${var.cluster_name}"
    }
  }
}
