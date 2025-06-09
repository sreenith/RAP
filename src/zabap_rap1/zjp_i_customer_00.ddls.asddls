@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Interface'

define root view entity ZJP_I_Customer_00
  as select from zjp_customer_00
  association [0..1] to I_CountryText as _Country on  _Country.Country = zjp_customer_00.land1
                                                  and _Country.Language = 'E'
{
  key customer_uuid         as CustomerUuid,
      kunnr                 as Customer,
      name                  as Name,
      land1                 as Country,
      ort01                 as City,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      _Country
}
