.PHONY: all build deploy port-forward clean

all: build deploy

build:
	packer init nginx.pkr.hcl && packer build nginx.pkr.hcl

deploy:
	ansible-playbook deploy.yml

port-forward:
	@echo "L'application est accessible sur le port 8081"
	@echo "Vérifiez l'onglet PORTS et passez le 8081 en PUBLIC"
	kubectl port-forward svc/nginx 8081:80

clean:
	kubectl delete deployment nginx || true
	kubectl delete service nginx || true
	k3d image delete nginx-custom:latest || true