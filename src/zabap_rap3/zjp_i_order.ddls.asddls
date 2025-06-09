@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Root Entity'
define root view entity ZJP_I_ORDER as select from zjp_order
composition [0..* ] of ZJP_I_ITEM as _item
{
    key ordernumber as Ordernumber,
    ordertype as Ordertype,
    salesorg as Salesorg,
    distchannel as Distchannel,
    division as Division,
    customer as Customer,
    grossamount as Grossamount,
    currency as Currency,
    status as Status,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    locallastchangedat,
    @Semantics.systemDateTime.lastChangedAt: true 
    lastchangedat,
    _item  // Make association public
}
