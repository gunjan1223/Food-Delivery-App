pipeline{
    agent any
    tools{
        jdk'jdk17'
        nodejs'node23'
    }
    environment{
        SCANNER_HOME=tool'sonar-scanner'
    }
    stages{
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkou from Git'){
            steps{
               git branch: 'main', url: 'https://github.com/gunjan1223/Food-Delivery-App.git'
            }
        }
        stage("Sonarqube Analysis"){
            steps{
                 withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Food-App \
                    -Dsonar.projectKey=Food-App '''
                }
            }
        }
        stage("Quality Gate"){
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
        stage('OWASP FS SCAN'){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'docker-creds', toolName: 'docker'){
                        sh "docker build -t food-app ."
                        sh "docker tag food-app gunjan04/food-app:latest "
                        sh "docker push gunjan04/food-app:latest "
                    }
                }
            }
        }
        stage("Trivy"){
            steps{
                sh "trivy image gunjan04/food-app:latest > trivy.txt"
            }
        }
        stage('Deploy to Container'){
            steps{
                sh 'docker run -d --name food-app -p 3000:3000 gunjan04/food-app:latest'
            }
        }
    }
}
