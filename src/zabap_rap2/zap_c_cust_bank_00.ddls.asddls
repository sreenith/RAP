@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZAP_I_CUST_BANK_00'
@ObjectModel.semanticKey: [ 'RecordNumber' ]
define root view entity ZAP_C_CUST_BANK_00
  provider contract transactional_query
  as projection on ZAP_I_CUST_BANK_00
{
  key customeruuid,
  key recordnumber,
  kunnr,
  bankn,
  swift,
  locallastchangedat
  
}
