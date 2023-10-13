act-plebnet-playground:docker-start## 	run act -vbr -W .github/workflows/plebnet-playground.yml
	@pushd $(PWD) && GITHUB_TOKEN=$(cat ~/GITHUB_TOKEN.txt) && act -vb -W .github/workflows/plebnet-playground.yml && popd
act-nostr-rs-relay:docker-start## 	run act -vbr -W .github/workflows/nostr-rs-relay.yml
	@pushd $(PWD) && GITHUB_TOKEN=$(cat ~/GITHUB_TOKEN.txt) && act -vb -W .github/workflows/nostr-rs-relay.yml && popd
act-codeql-analysis:docker-start## 	run act -vbr -W .github/workflow/codeql-analysis.yml
	@pushd $(PWD) && export $(cat ~/GITHUB_TOKEN.txt) && act -vb -W .github/workflows/codeql-analysis.yml && popd
act-codespell:docker-start## 	run act -vbr -W .github/workflow/codespell.yml
	@pushd $(PWD) && GITHUB_TOKEN=$(cat ~/GITHUB_TOKEN.txt) && act -vb -W .github/workflows/codespell.yml && popd
