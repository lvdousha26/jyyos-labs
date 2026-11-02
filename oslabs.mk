# 令牌保存在本地未跟踪的 .token 文件中，避免泄露到公开仓库
TOKEN_FILE := $(dir $(abspath $(lastword $(MAKEFILE_LIST)))).token
export TOKEN ?= $(shell cat $(TOKEN_FILE) 2>/dev/null)

# ----- DO NOT MODIFY -----

export COURSE := OS2024
URL := 'https://jyywiki.cn/submit.sh'

submit:
	@cd $(dir $(abspath $(lastword $(MAKEFILE_LIST)))) && \
	  curl -sSLf '$(URL)' > /dev/null && \
	  curl -sSLf '$(URL)' | bash

git:
	@find ../.shadow/ -maxdepth 1 -type d -name '[a-z]*' | xargs rm -rf
	@cp -r `find .. -maxdepth 1 -type d -name '[a-z]*'` ../.shadow/
	@git add ../.shadow -A --ignore-errors
	@while (test -e .git/index.lock); do sleep 0.1; done
	@(uname -a && uptime) | git commit -F - -q --no-verify --allow-empty
	@sync
