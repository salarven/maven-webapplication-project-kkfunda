pipeline {
    agent any

    tools {
        maven "maven-3.9.9"
    }

    triggers {
        pollSCM('* * * * *')
        // githubPush()   // Use this instead if using GitHub webhook
    }

    stages {
        stage('git checkout') {
            steps {
                git branch: 'dev',
                    url: 'https://github.com/salarven/maven-webapplication-project-kkfunda.git'
            }
        }

        stage('Build') {
            steps {
                sh "mvn clean package"
            }
        }

        stage('sona report') {
            steps {
                sh "mvn clean sonar:sonar"
            }
        }

        stage('Nexus backup') {
            steps {
                sh "mvn clean deploy"
            }
        }

        stage('Deploy Tomcat') {
            steps {
                sh """
                curl -u ram:1234 \
                --upload-file /var/lib/jenkins/workspace/Declarative\\ pipe\\ line/target/maven-web-application.war \
                "http://54.208.237.132:8080/manager/text/deploy?path=/maven-web-application&update=true"
                """
            }
        }
    }

    post {
        success {
            notifybuild(currentBuild.result)
        }
        failure {
            notifybuild(currentBuild.result)
        }
    }
}

def notifybuild(String buildStatus = 'STARTED') {

    buildStatus = buildStatus ?: 'SUCCESS'

    def colorCode
    def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
    def summary = "${subject} (${env.BUILD_URL})"

    switch (buildStatus) {
        case 'STARTED':
            colorCode = '#FFFF00'
            break

        case 'SUCCESS':
            colorCode = '#00FF00'
            break

        default:
            colorCode = '#FF0000'
            break
    }

    echo summary
}
  
