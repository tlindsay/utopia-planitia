# Raspberry Pi Image Build Workflow

This GitHub Actions workflow automatically builds Raspberry Pi SD card images for all the systems defined in this flake.

## How it works

1. Whenever changes are pushed to the main branch that affect system configurations, flake files, or this workflow, GitHub Actions will automatically start building images.
2. Each system (unimatrix01, unimatrix02, unimatrix03, unimatrix04, and subspace-relay) is built in parallel.
3. The resulting SD card images are uploaded as artifacts that you can download from the GitHub Actions page.

## Accessing the images

1. Go to the "Actions" tab in your GitHub repository
2. Select the latest successful "Build Raspberry Pi Images" workflow run
3. Scroll down to the "Artifacts" section
4. Download the artifact for the system you want to flash

## Manual trigger

You can also manually trigger a build by:
1. Going to the "Actions" tab
2. Selecting "Build Raspberry Pi Images"
3. Clicking "Run workflow"
4. Selecting the branch and clicking "Run workflow"

## Releases

When you create a new tag in the repository, the workflow will automatically attach the built images to a GitHub release with that tag name.

## Setup required

For this workflow to function properly, you need to:

1. Set up a Cachix cache named "utopia-planitia" 
2. Add a repository secret called `CACHIX_AUTH_TOKEN` with your Cachix authentication token

This ensures builds are cached and speeds up the process significantly.