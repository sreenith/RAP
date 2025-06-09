@EndUserText.label: 'Table for Swift Code Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_TableForSwiftCode_S
  as select from I_Language
    left outer join ZAP_SWIFT_00 on 0 = 0
  composition [0..*] of ZI_TableForSwiftCode as _TableForSwiftCode
{
  key 1 as SingletonID,
  _TableForSwiftCode,
  max( ZAP_SWIFT_00.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
