pipeline {
    agent any

    environment {
        // Credentials binding
        CF_API_TOKEN = credentials('cf-api-token')
        CF_ZONE_ID = credentials('cf-zone-id')
        CF_ACCOUNT_ID = credentials('cf-account-id')
        CF_DOMAIN = credentials('cf-domain')
        TUNNEL_ID_DOCKER = credentials('tunnel-id-docker')
        TUNNEL_SECRET_DOCKER = credentials('tunnel-secret-docker')
        TF_TOKEN_app_terraform_io = credentials('tf_cloud_token')
        GITHUB_SSH_KEY = credentials('github-ssh-key')

        // Set Terraform variables once
        TF_VAR_cf_api_token = "${CF_API_TOKEN}"
        TF_VAR_cf_zone_id = "${CF_ZONE_ID}"
        TF_VAR_cf_account_id = "${CF_ACCOUNT_ID}"
        TF_VAR_cf_domain = "${CF_DOMAIN}"
        TF_VAR_tunnel_id_docker = "${TUNNEL_ID_DOCKER}"
        TF_VAR_tunnel_secret_docker = "${TUNNEL_SECRET_DOCKER}"
    }

    stages {
        stage('Setup SSH') {
            steps {
                sh '''
                    mkdir -p ~/.ssh
                    echo "$GITHUB_SSH_KEY" > ~/.ssh/id_rsa
                    chmod 600 ~/.ssh/id_rsa
                    ssh-keyscan github.com >> ~/.ssh/known_hosts
                '''
            }
        }

        stage('Install Prerequisites') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y wget gnupg2 lsb-release software-properties-common curl
                '''
            }
        }

        stage('Install Terraform') {
            steps {
                sh '''
                    # Download and add the HashiCorp GPG key without interactive prompt
                    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -

                    # Add the HashiCorp repository
                    echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

                    # Update and install Terraform
                    apt-get update
                    apt-get install -y terraform

                    # Verify installation
                    terraform --version
                '''
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-ssh-key',
                    url: 'git@github.com:fabricesemti80/clouds-cloudflare.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Apply the plan?'
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        always {
            sh '''
                rm -f ~/.ssh/id_rsa
                rm -f tfplan
            '''
            cleanWs()
        }
    }
}
