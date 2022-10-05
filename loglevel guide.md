## Log level 설정 가이드

## 1. prometheus-operator

prometheus-operator 내 prometheus-operator 컨테이너는 --log-level=(degub, info, error, fatal) 로 지정
prometheus-operator 내 kube-rbac-proxy 컨테이너는 --v=(0~5)으로 지정

## 2. prometheus

prometheus CR 내 spec.logLevel 에debug, error, info, warn으로 작성
(config-reloader 도 자동으로 같이 설정됨)

## 3. kube-state-metrics

deployment의 args 에 --v=x(0,1,2,3,4,5) (5가 로 설정
(kube-rbac-proxy 포함)

## 4. node-exporter

node-exporter 내 node-exporter 컨테이너는 args에 --log.level=error 로 지정
node-exporter 내 kube-rbac-proxy 컨테이너는 --v=0으로 지정

## 5. alertmanager

alertmanager CR 내 spec.logLevel 에debug, error, info, warn으로 작성

## 6. prometheus-adapter

deployment의 args에 --v=x(0~10)로 설정 (10이 info)
