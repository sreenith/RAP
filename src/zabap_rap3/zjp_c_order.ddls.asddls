@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Root Entity Projection'
@Metadata.allowExtensions: true
define root view entity ZJP_C_ORDER
  provider contract transactional_query
  as projection on ZJP_I_ORDER
{
  key Ordernumber,
      Ordertype,
      Salesorg,
      Distchannel,
      Division,
      Customer,
      Grossamount,
      Currency,
      Status,
      locallastchangedat,
      lastchangedat,
      /* Associations */
      _item : redirected to composition child zjp_c_item
}
