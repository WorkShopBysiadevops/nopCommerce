pipeline{
  agent{
    label 'nop'
  }
  stages{
    stage('git'){
      steps{
        git branch: 'develop',
            url: 'https://github.com/WorkShopBysiadevops/Terraform-June24.git'
      }
    }
    stage('build and push'){
      steps{
        sh(script: 'docker build -t siadevops/nopcoommerce:latest .')
        sh(script: 'docker push siadevops/nopcoommerce:latest')
      }
    }
    stage(infraprovisioning){
     steps{
      sh(script: 'cd infra/Terraform && ls -al && pwd && terraform init && terraform workspace select dev && terraform apply -lock=false -var-file="dev.tfvars" -var "build_number=${BUILD_ID}" -auto-approve')
     }    
    }
    stage('k8s deploy'){
      steps{
        sh(script: 'kubectl apply -f infra/k8s')
      }
    }
  }
}