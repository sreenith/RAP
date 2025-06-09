@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Entity'
define view entity ZJP_I_ITEM
  as select from zjp_item
  association to parent ZJP_I_ORDER as _order on $projection.Ordernumber = _order.Ordernumber
{
  key ordernumber as Ordernumber,
  key itemnumber as Itemnumber,
      product as Product,
      plant      as Plant,
      quantity   as Quantity,
      uom        as Uom,
      netamount  as Netamount,
      currency   as Currency,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat1,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat1,
      _order // Make association public
}
      
