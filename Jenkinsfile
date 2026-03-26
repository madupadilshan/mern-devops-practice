pipeline {
    // ඕනෑම Jenkins පරිගණකයක මෙය ධාවනය වීමට ඉඩ දීම
    agent any

    // අපේ පරිසර විචල්‍යයන් (Environment Variables)
    environment {
        DOCKER_USER = "madupadilshan"
        IMAGE_BACKEND = "madupadilshan/mern-backend"
        IMAGE_FRONTEND = "madupadilshan/mern-frontend"
        TAG = "latest"
    }

    stages {
        // අදියර 1: GitHub එකෙන් කේතය ලබාගැනීම
        stage('1. Checkout Code') {
            steps {
                checkout scm
            }
        }

        // අදියර 2: කේතයේ ආරක්ෂාව පරීක්ෂා කිරීම (SAST & SCA)
        stage('2. Security Scan (Filesystem)') {
            steps {
                echo "Running Trivy Filesystem Scan for Vulnerabilities..."
                // මෙහිදී අපි Trivy Docker Image එක භාවිතා කර මුළු කේතයම ස්කෑන් කරමු
                sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v ${WORKSPACE}:/rootfs aquasec/trivy fs /rootfs --no-progress --exit-code 0 --severity HIGH,CRITICAL'
            }
        }

        // අදියර 3: අලුත් Docker Images සෑදීම
        stage('3. Build Docker Images') {
            steps {
                echo "Building Backend & Frontend Images..."
                sh 'docker build -t ${IMAGE_BACKEND}:${TAG} ./backend'
                sh 'docker build -t ${IMAGE_FRONTEND}:${TAG} ./frontend'
            }
        }

        // අදියර 4: හැදූ Images වල OS මට්ටමේ දෝෂ සෙවීම (Container Scan)
        stage('4. Container Security Scan') {
            steps {
                echo "Scanning Images with Trivy..."
                sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --no-progress --exit-code 0 --severity HIGH,CRITICAL ${IMAGE_BACKEND}:${TAG}'
                sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --no-progress --exit-code 0 --severity HIGH,CRITICAL ${IMAGE_FRONTEND}:${TAG}'
            }
        }

        // අදියර 5: Docker Hub එකට Images යැවීම (Push)
        stage('5. Push to Docker Hub') {
            steps {
                // Jenkins හි අපි හදන 'docker-hub-credentials' හරහා ආරක්ෂිතව ලොග් වීම
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER_ID')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER_ID --password-stdin'
                    sh 'docker push ${IMAGE_BACKEND}:${TAG}'
                    sh 'docker push ${IMAGE_FRONTEND}:${TAG}'
                }
            }
        }

        // අදියර 6: AWS සර්වර් එකේ යෙදුම ධාවනය කිරීම (Deploy)
        stage('6. Deploy to AWS Server') {
            steps {
                echo "Deploying the MERN Application..."
                // පරණ කන්ටේනර් ඇත්නම් ඒවා ඉවත් කර, අලුත් කන්ටේනර් ධාවනය කිරීම
                sh 'docker compose down || true'
                sh 'docker compose up -d'
            }
        }
    }

    // Pipeline එක අවසානයේ අනිවාර්යයෙන්ම සිදුවිය යුතු දේ (ආරක්ෂාව සඳහා)
    post {
        always {
            sh 'docker logout'
            echo "Pipeline Execution Completed!"
        }
    }
}
