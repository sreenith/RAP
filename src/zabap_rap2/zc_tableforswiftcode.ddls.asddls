@EndUserText.label: 'Table for Swift Code - Maintain'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TableForSwiftCode
  as projection on ZI_TableForSwiftCode
{
  key SwiftUuid,
  Swift,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  LastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _TableForSwiftCodAll : redirected to parent ZC_TableForSwiftCode_S
  
}
