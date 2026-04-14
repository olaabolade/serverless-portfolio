# Setup Guide: Zero-Maintenance Portfolio

This guide will help you deploy your portfolio on AWS in about 30 minutes.

## What you need before starting

- An AWS account (free tier works)
- Your portfolio code on GitHub
- Basic knowledge of using a terminal

## Step 1: Prepare your portfolio files

Before deploying, edit these two files:

1. Open `config.json` and replace the placeholder data with your name, bio, skills, and projects
2. Add your profile photo to the `images` folder and update the `avatar` path in config.json

Test locally by running `python -m http.server 8000` and opening `http://localhost:8000` in your browser.

## Step 2: Create an S3 bucket

1. Log into AWS Console at https://console.aws.amazon.com
2. Search for "S3" and click on it
3. Click the orange "Create bucket" button
4. Bucket name: choose something unique like `yourname-portfolio`
5. Region: select the one closest to you (us-east-1 works well)
6. Scroll down to "Object Ownership" and select "ACLs enabled"
7. Uncheck "Block all public access"
8. Check the box acknowledging the bucket will be public
9. Click "Create bucket"

## Step 3: Enable static website hosting

1. Click on your newly created bucket
2. Go to the "Properties" tab
3. Scroll to "Static website hosting"
4. Click "Edit"
5. Select "Enable"
6. Index document: type `index.html`
7. Error document: type `index.html`
8. Click "Save changes"

## Step 4: Make your bucket public

1. Go to the "Permissions" tab
2. Scroll to "Bucket policy"
3. Click "Edit"
4. Paste this policy (replace `yourname-portfolio` with your actual bucket name):

{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Principal": "*",
"Action": "s3:GetObject",
"Resource": "arn:aws:s3:::yourname-portfolio/*"
}
]
}

5. Click "Save changes"

## Step 5: Upload your files

Open a terminal in your project folder and run:

aws s3 sync . s3://yourname-portfolio --exclude ".git/*" --exclude "SETUP.md"

If you do not have AWS CLI installed, you can upload manually:
1. In your S3 bucket, click "Upload"
2. Drag and drop `index.html`, `config.json`, and the `images` folder
3. Click "Upload"

## Step 6: Set up auto-deploy with CodePipeline

This step makes your portfolio update whenever you push to GitHub.

1. In AWS Console, search for "CodePipeline" and open it
2. Click "Create pipeline"
3. Pipeline name: `portfolio-pipeline`
4. Service role: select "New service role"
5. Click "Next"

**Source stage:**
1. Source provider: select "GitHub (Version 2)"
2. Click "Connect to GitHub" and authorize AWS
3. Repository: select your GitHub repo
4. Branch: select `main` (or `standard-version` if using that branch)
5. Change detection: select "GitHub webhooks"
6. Click "Next"

**Build stage:**
1. Skip build stage (check the box)
2. Click "Next"

**Deploy stage:**
1. Deploy provider: select "Amazon S3"
2. Bucket: select the bucket you created (`yourname-portfolio`)
3. Click "Next"

4. Review and click "Create pipeline"

## Step 7: Find your live website URL

1. Go back to your S3 bucket
2. Click the "Properties" tab
3. Scroll to "Static website hosting"
4. You will see a URL like: `http://yourname-portfolio.s3-website-us-east-1.amazonaws.com`

Open that URL in your browser. You should see your portfolio live.

## How auto-deploy works

Now every time you push changes to your GitHub repository:
1. CodePipeline detects the change
2. It automatically deploys the new files to S3
3. Your website updates within 2-3 minutes

## Troubleshooting

**My website shows a blank page**
- Check that `index.html` is in the root of your S3 bucket
- Make sure the bucket policy is correctly pasted

**Images are not loading**
- Check that the `images` folder was uploaded
- Verify the file paths in `config.json`

**CodePipeline is not triggering**
- Go to CodePipeline and check if the pipeline shows "Failed"
- Click on the failed stage to see the error message

## Need help?

Email me at [your support email] and I will respond within 24 hours.

---

Congratulations! You now have a zero-maintenance portfolio that updates itself when you push to GitHub.