@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Projection'
@Metadata.allowExtensions: true
define view entity zjp_c_item
  as projection on ZJP_I_ITEM
{
  key Ordernumber,
  key Itemnumber,
      Product,
      Plant,
      Quantity,
      Uom,
      Netamount,
      Currency,
      locallastchangedat1,
      lastchangedat1,
      /* Associations */
      _order : redirected to parent ZJP_C_ORDER
}
