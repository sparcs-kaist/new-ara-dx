## DX 컨테이너 사용법
### 3줄 요약
- `dc up -d` 로 컨테이너들을 켜고 `dc down` 으로 컨테이너를 내리세요.
- VSCode에서 api, web-dev 컨테이너를 Dev Containers로 붙여 개발하실 수 있습니다.
- 처음 디렉토리를 물어볼 때 api 컨테이너는 `/newara/www`, web-dev 컨테이너는 `/usr/src/app` 를 작업 디렉토리로 설정해 주세요.

### 설명
- `api`, `web` 디렉토리에는 ECR 이미지 기반 DX용 이미지 생성용 `Dockerfile` 이 들어 있습니다.
    - git clone을 통해 받아온 코드를 사용하지 않는 이유는 github secret으로부터 여러 env 및 credential들을 받아오기 위함입니다. (e.g. firebase 관련 json)
- `web-dev` 디렉토리에는 web repo 기반의 Dockerfile이 있습니다. 위의 web 디렉토리와 다른 점은 prod, dev용 nginx 기반이 아닌, 실제 프론트 개발 환경용 node 기반의 이미지를 사용하고 있고, `npm run serve` 로 띄우셔야 합니다.
    - 사용을 원한는 경우 `docker-compose`에서 기존 `web` 대신 `80:8080` 포트 매핑을 추가해 주세요.
- `es/synonym.txt` 는 elasticsearch 에 사용되는 synonym 파일입니다. ara-es내 synonym.txt와 bind 되어있습니다.
- `.api.env` 에는 api 컨테이너용 환경변수들이 포함되어 있습니다. dind docker-compose에 환경변수를 잘 넣어 주었다면 모든 변수가 알맞게 채워져 있을 것입니다.
- `login.sh` 스크립트는 Newara ECR 에 접근하기 위해 AWS에 로그인하는 스크립트입니다. 직접 실행하실 필요는 없습니다.
- `docker-compose.yml` 에 뉴아라 프론트 및 벡엔드를 띄우기 위한 컨테이너 설정들이 포함되어 있습니다.


### 특징
- 이 디렉토리의 파일들은 본인의 설정에 맞게 자동 생성되었으며, 따라서 일반적으로 해당 디렉토리 내 파일들을 **직접 수정하실 필요가 없습니다**.
- `docker compose`는 `dc`, `docker` 는 `d`로 alias가 추가되어 있습니다.
- `dc up -d` 로 뉴아라 스택을 띄울 수 있습니다.
- `dc down` 으로 뉴아라 스택을 내릴 수 있습니다.
- `dc ps -a` 로 현재 컨테이너 상태를 확인할 수 있습니다.
- `dc exec api bash`, `dc exec web bash` 등으로 해당 컨테이너에 접속할 수 있습니다.
- `dc logs -f` 로 컨테이너들의 로그를 확인할 수 있습니다. 뒤에 `api` `web` 등을 붙여 특정 컨테이너 로그를 확인할 수 있습니다.
- VSCode에서 특정 컨테이너 (api)에서 개발을 원하는 경우 Ctrl+Shift+P를 눌러 Dev Containers:Attach to Running Container 옵션을 눌러 원하는 컨테이너를 선택해 주세요.
    - api 컨테이너의 경우 기본 디렉토리를 `/root/api` 로,  web 컨테이너는 `/root/web` 로 선택해 주세요.
    - 디렉토리를 잘못 선택한 경우 dind 컨테이너에서 Ctrl+Shift+P를 눌러 Remote-Containers: Open attached container configuration file를 통해 바꿔 주세요.