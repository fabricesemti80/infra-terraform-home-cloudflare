#

## Update - 21/03/2025

- moved to [Terraform Cloud workspace](https://app.terraform.io/app/homelab-fsemti/workspaces/tf-cloudflare)

## Update - 30/10/2024

- Moved state to [Terraform Cloud back end](https://app.terraform.io/app/homelab-fsemti/workspaces/homelab-fsemti)
- note: variables added as env vars on the workspace with `TF_VAR_` prefix

## Running Cloudflared Docker Container

To run cloudflared in a Docker container for tunnel connectivity:

```bash
docker run -d \
  --name cloudflared \
  -e TUNNEL_TOKEN=<your-tunnel-token> \
  cloudflare/cloudflared \
  tunnel run
```

**Important:** When changing the `TUNNEL_TOKEN` environment variable, the container must be restarted to pick up the new token:

```bash
docker restart cloudflared
```

The container uses the token to authenticate and fetch tunnel configuration from Cloudflare in managed mode.

## Getting Cloudflare tunnel details

- `cloudflared login` - log in to cloudflared
- `cat ~/.cloudflared/ <file name>` - check the files, if there is one for the tunnel in question (use `cloudflared tunnel list` to view exiting tunels)

## 3rd party ref

https://github.com/marco-lancini/utils/tree/8f0bc86c837a6b963845fde500bd04bd0a9c669d/terraform/aws-ec2-zero-trust/terraform/modules/cloudflare-access-app
