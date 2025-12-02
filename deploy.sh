#!/bin/bash

echo "========================================="
echo "자동 빌드 및 배포 시작..."
echo "========================================="

# 1. Minikube Docker 환경 사용
eval $(minikube docker-env)

# 2. Docker 이미지 빌드 (캐시 무시)
echo ""
echo "📦 Docker 이미지 빌드 중..."
docker build --no-cache -t test-web-app:latest .

if [ $? -eq 0 ]; then
    echo "✅ 빌드 성공!"
else
    echo "❌ 빌드 실패!"
    exit 1
fi

# 3. Deployment 삭제 후 재생성 (이미지 확실히 교체)
echo ""
echo "🚀 Kubernetes 배포 업데이트 중..."
kubectl delete deployment test-web-app
kubectl apply -f deployment.yaml

# 4. 배포 상태 확인
echo ""
echo "⏳ 배포 상태 확인 중..."
kubectl rollout status deployment/test-web-app

# 5. Pod 상태 확인
echo ""
echo "📊 현재 Pod 상태:"
kubectl get pods -l app=test-web-app

echo ""
echo "========================================="
echo "✅ 배포 완료!"
echo "브라우저에서 Ctrl+Shift+R로 새로고침하세요"
echo "========================================="
