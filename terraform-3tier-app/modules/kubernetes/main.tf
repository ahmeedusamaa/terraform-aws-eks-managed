resource "kubernetes_persistent_volume" "jenkins-pv" {
  metadata { name = "jenkins-pv" }

  spec {
    capacity                         = { storage = "10Gi" }
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Delete"

    persistent_volume_source {
      aws_elastic_block_store {
        volume_id = "vol-06f6f3e08a3cd3156"
        fs_type   = "ext4"
      }
    }
  }
}


resource "kubernetes_persistent_volume_claim" "jenkins-pvc" {
  metadata {
    name      = "jenkins-pvc"
    namespace = "jenkins"
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources { requests = { storage = "10Gi" } }
    volume_name = kubernetes_persistent_volume.jenkins-pv.metadata[0].name
  }
}
