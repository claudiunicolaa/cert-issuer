cp node_modules/vc-test-suite/implementations/index.html ./vc-compliance-report.html

COMPLIANCE_RESULT=$( cat node_modules/vc-test-suite/implementations/test-status.txt )
echo $COMPLIANCE_RESULT
echo ($COMPLIANCE_RESULT == "compliant")
if [ $COMPLIANCE_RESULT == "compliant" ];
  then BADGE_COLOR="green";
  else BADGE_COLOR="red";
fi
## replace first line of README with new badge value - couldn't get sed to work properly
echo "[![Verifiable Credential Compliance result](https://badgen.net/badge/Verifiable%20Credentials%20v1/$COMPLIANCE_RESULT/$BADGE_COLOR?icon=https://www.w3.org/Icons/WWW/w3c_home_nb-v.svg)](https://github.com/blockchain-certificates/cert-issuer/vc-compliance-report.html)" >> /tmp/cert-issuer-readme
tail -n +2 README.md >> /tmp/cert-issuer-readme
mv /tmp/cert-issuer-readme README.md

git checkout $TRAVIS_BRANCH
git status
git add vc-compliance-report.html README.md
git commit -m "chore(Compliance): update compliance report"
echo "Pushing changes to $TRAVIS_BRANCH"
git config credential.helper "store --file=.git/credentials"
echo "https://${GH_TOKEN}:@github.com" > .git/credentials
git push origin $TRAVIS_BRANCH --verbose
