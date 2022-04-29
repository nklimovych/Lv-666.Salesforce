# Salesforce Exceptions Handling Utility

_To start using the utility you need to install [Salesforce CLI](https://developer.salesforce.com/tools/sfdxcli)._

## Please do next actions to start using the utility:
1. Clone `exception-utility` repository;

2. Open a Terminal/Console/Shell within the cloned folder;

3. Run `sfdx force:auth:web:login -s` to login to your environment;

4. Login to your environment in opened browser page;

5. Run `sfdx force:source:deploy -p force-app/main/default` to deploy all the metadata;

6. Make sure that deployment finished without any errors;

7. Close the Terminal/Console/Shell;

## Utility's usage example:
```java
try {
    // ...your code
} catch (Exception e) {
    System.enqueueJob(new ExceptionUtility(e));
}
```
