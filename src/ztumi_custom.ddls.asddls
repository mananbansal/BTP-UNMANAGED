@EndUserText.label: 'custom entity'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_ZCUS_DETAILS'
@UI:{
    headerInfo :{
        typeName: 'Custom Report',
        typeNamePlural: 'Custom Reports'
    },
     presentationVariant: [{
        sortOrder: [{
            by: 'Docno',
            direction: #ASC
        }],
        visualizations: [{
            type: #AS_LINEITEM
        }]
    }]
}
define root custom entity ZTUMI_CUSTOM
{
  @UI:{
        lineItem: [{ position: 10  , importance: #HIGH , label: 'Document Number'}],
        selectionField: [{ position: 10 }]
        
  }
  @EndUserText.label: 'Document Number'
  key Docno  :   z_doc_number;
  @UI:{
        lineItem: [{ position: 11  , importance: #HIGH , label: 'Item Number'}],
        selectionField: [{ position: 11 }]
        
  }
  @EndUserText.label: 'Item Number'
  key ItemNumber : z_itm_no;
  
  @UI:{
        lineItem: [{ position: 20  , importance: #HIGH , label: 'Status'}],
        selectionField: [{ position: 20 }]
        
  }
  @EndUserText.label: 'Status'
  
  Status : z_status;
  
  @UI:{
        lineItem: [{ position: 30  , importance: #HIGH , label: 'Currency'}],
        selectionField: [{ position: 30 }]
        
  }
  @EndUserText.label: 'Currency'
  
  Currency : z_currency;
  
  @UI:{
        lineItem: [{ position: 40  , importance: #HIGH , label: 'Created By'}],
        selectionField: [{ position: 40 }]
        
  }
  @EndUserText.label: 'Created By'
  
  Created_By : z_created_by;
  
   @UI:{
        lineItem: [{ position: 50  , importance: #HIGH , label: 'Quantity'}],
        selectionField: [{ position: 50 }]
        
  }
  @EndUserText.label: 'Quantity'
  Quantity : z_quantity;
   @UI:{
        lineItem: [{ position: 60  , importance: #HIGH , label: 'Amount'}],
        selectionField: [{ position: 60 }]
        
  }
  @EndUserText.label: 'Amount'
  @Semantics.amount.currencyCode: 'Currency'
  Amount  : z_amount;
}
