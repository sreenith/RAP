@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Customer Bank'
define root view entity ZAP_I_CUST_BANK_00
  as select from zap_cust_bank_00 as Customer
{
  key customer_uuid as CustomerUUID,
  key record_number as RecordNumber,
  kunnr as Kunnr,
  bankn as Bankn,
  swift as Swift,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
  
}
