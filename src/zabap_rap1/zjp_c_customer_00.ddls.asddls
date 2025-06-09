@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Consumption'
@Metadata.allowExtensions: true
define root view entity ZJP_C_CUSTOMER_00
  provider contract transactional_query
  as projection on ZJP_I_Customer_00

{
  key CustomerUuid,
      Customer,
      Name,
      Country,
      _Country.CountryName,
      City,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt
}
