@EndUserText.label: 'Table for Swift Code'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_TableForSwiftCode
  as select from ZAP_SWIFT_00
  association to parent ZI_TableForSwiftCode_S as _TableForSwiftCodAll on $projection.SingletonID = _TableForSwiftCodAll.SingletonID
{
  key SWIFT_UUID as SwiftUuid,
  SWIFT as Swift,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  1 as SingletonID,
  _TableForSwiftCodAll
  
}
