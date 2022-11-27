pipeline {
    agent any

    stages {
        stage('Clone Terraform Repo') {
            steps {
                echo 'Hello World'
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'GitHub', url: 'https://github.com/htaylor777/terraform_aws_test.git']]])
        }}
        stage('Terraform Provision') {
            steps {
                sh """
                    terraform init
                    terraform plan
                    terraform apply --auto-approve
                """
                sh 'pwd'
            }
        }
        stage('Time to Kill?') {
            steps {
                input message: 'Destroy terraform resources?'
            }
        }
        stage('Search and Destroy') {
            steps {
                sh 'terraform destroy --auto-approve'
            }
        }
    }
}
