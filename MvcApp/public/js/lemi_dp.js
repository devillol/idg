
  var startDateDef = new Date('2019-12-01');
var endDateDef = new Date('2020-01-31');
 $('.input-daterange').datepicker({
    orientation: 'bottom auto',
    format: 'yyyy-mm-dd',
    weekStart: 1,
    startDate: startDateDef,
    endDate: endDateDef,
    datesDisabled: ['2019-12-20','2019-12-23','2019-12-26','2020-01-05','2020-01-07','2020-01-09','2020-01-24'],
    todayHighlight: true,
    clearBtn: true
});
