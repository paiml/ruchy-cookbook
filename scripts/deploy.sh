#!/usr/bin/env bash
# Deploy cookbook to S3/CloudFront
# Production deployment script

set -euo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Production configuration
S3_BUCKET="interactive.paiml.com-production-mcb21d5j"
CLOUDFRONT_DIST="ELY820FVFXAFF"
SITE_URL="https://interactive.paiml.com/cookbook"

echo -e "${CYAN}🚀 Deploying Ruchy Cookbook to Production${NC}"
echo "=========================================="
echo ""
echo -e "${YELLOW}Target: $SITE_URL${NC}"
echo -e "${YELLOW}S3 Bucket: $S3_BUCKET${NC}"
echo -e "${YELLOW}CloudFront: $CLOUDFRONT_DIST${NC}"
echo ""

# Check AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI not installed${NC}"
    echo -e "${YELLOW}Install: https://aws.amazon.com/cli/${NC}"
    exit 1
fi

# Check book is built
if [ ! -d "book" ]; then
    echo -e "${RED}❌ Book not built${NC}"
    echo -e "${YELLOW}Run: make build${NC}"
    exit 1
fi

# Deploy to S3
echo -e "${CYAN}1️⃣  Syncing to S3...${NC}"
aws s3 sync book/ "s3://$S3_BUCKET/cookbook/" \
    --delete \
    --cache-control "max-age=3600" \
    --exclude ".git/*" \
    --exclude ".DS_Store"

echo -e "${GREEN}✅ S3 sync complete${NC}"
echo ""

# Invalidate CloudFront cache
echo -e "${CYAN}2️⃣  Invalidating CloudFront cache...${NC}"
aws cloudfront create-invalidation \
    --distribution-id "$CLOUDFRONT_DIST" \
    --paths "/cookbook/*"

echo -e "${GREEN}✅ CloudFront invalidation initiated${NC}"
echo ""

# Verify deployment
echo -e "${CYAN}3️⃣  Verifying deployment...${NC}"
sleep 5  # Wait for propagation

if curl -f "$SITE_URL/" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Site is accessible${NC}"
else
    echo -e "${RED}❌ Site verification failed${NC}"
    exit 1
fi

echo ""
echo "=========================================="
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo "=========================================="
echo ""
echo -e "📖 View at: ${CYAN}$SITE_URL${NC}"
echo ""
