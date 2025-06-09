@EndUserText.label: 'Table for Swift Code Singleton - Maintai'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_TableForSwiftCode_S
  provider contract transactional_query
  as projection on ZI_TableForSwiftCode_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _TableForSwiftCode : redirected to composition child ZC_TableForSwiftCode
  
}
