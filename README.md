pipeline {
    agent any
    environment {
        URLS = "http://internal-url-1.com http://internal-url-2.com http://internal-url-3.com"
    }
    stages {
        stage('Monitor URLs') {
            steps {
                script {
                    def urls = env.URLS.split(" ")
                    for (url in urls) {
                        sh """
                            echo "Checking URL: ${url}"
                            response=$(curl -o /dev/null -s -w "%{http_code}\n" ${url})
                            echo "Response code for ${url}: ${response}"
                            if [ "$response" -ne 200 ]; then
                                echo "ERROR: ${url} is not reachable or returned non-200 status code"
                                exit 1
                            fi
                        """
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Finished monitoring URLs'
        }
        failure {
            mail to: 'your-email@example.com',
                 subject: "URL Monitoring Job Failed",
                 body: "One or more URLs are not reachable. Please check Jenkins job for details."
        }
    }
}

