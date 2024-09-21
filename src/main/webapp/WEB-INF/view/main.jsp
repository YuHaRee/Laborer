<%@ page language='java' contentType='text/html; charset=UTF-8' pageEncoding='UTF-8'%>
<meta name='viewport' content='width=device-width, initial-scale=1'>
<script src='https://code.jquery.com/jquery-3.6.0.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js'></script>
<script src='https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js'></script>
<link rel='stylesheet' href='http://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.css'/>
<link rel='stylesheet' href='https://use.fontawesome.com/releases/v5.6.3/css/all.css'/>

<script>

function isVal(field) { //파라미터 필드를 넘겨준다.
   let isGood = false
   let errMsg
   
   if(!field.length) errMsg = '노동자를 선택하세요.' // radio 선택 했는지 확인.
   else {
      if(!field.val()) errMsg = field.attr('placeholder') + ' 입력하세요.' // 노동자 필드와 입사일 확인.
      else isGood = true
   }
   
   if(!isGood) { // err msg를 띄운다.
      $('#modalMsg').text(errMsg).css('color', 'red')
      $('#modalBtn').hide()
      $('#modal').modal()
   }
   
   return isGood
}

function listLaborers() {
   $('input').not(':radio').val('')
   $('#laborers').empty()
   
   $.ajax({
      url: 'laborer/list'
   }).done(laborers => {
      if(laborers.length) { 
            const laborerArr = []
   
            $.each(laborers, (i, laborer) => {
               laborerArr.unshift( 
                  `<tr>
                     <td><input value='\${laborer.laborerId}' type='radio' 
                                 name='laborerId' id='laborerId'/>
                     <td>\${laborer.laborerId}</td>
                     <td>\${laborer.name}</td>
                     <td>\${laborer.hireDate}</td>
                  </tr>`
               )   
            })
   
            $('#laborers').append(laborerArr.join(''))
         } else $('#laborers').append(
               '<tr><td colspan=4 class=text-center>노동자가 없습니다.</td></tr>')
   })
}

function init() {
   // 노동자 추가
   $('#addLaborerBtn').click(() => {
      if(isVal($('#laborerName')) && isVal($('#hireDate'))) {
         $.ajax({
            url: 'laborer/add',
            method: 'post',
            data: {
               laborerName: $('#laborerName').val(),
               hireDate: $('#hireDate').val()
            }
         }).done(listLaborers)
      }
   })

   $('#fixLaborerBtn').click(() => {
      if(isVal($('#laborerId:checked')) && isVal($('#laborerName')) && isVal($('#hireDate'))) {
         $.ajax({
            url: 'laborer/fix',
            method: 'put',
            contentType: 'application/json',
            data: JSON.stringify({
               laborerId :$('#laborerId:checked').val(),
               name: $('#laborerName').val(),
               hireDate: $('#hireDate').val()
            })
         }).done(listLaborers)
      }
   })
   
   $('#delLaborerBtn').click(() => {
      if(isVal($('#laborerId:checked'))) {
         $('#modalMsg').text('노동자를 삭제하시겠습니까?')
         $('#modalBtn').show()
         $('#modal').modal()
      }
   })

   $('#delLaborerOkBtn').click(() => {
      $('#modal').modal('hide')
      $.ajax({
         url: 'laborer/del/' + $('#laborerId:checked').val(),
         method: 'delete'
      }).done(listLaborers)
   })
   
   $('#laborers').on({
      change() {
         $('#laborerName').val($(this).parent().next().next().text())
         $('#hireDate').val($(this).parent().parent().next().next().text())
      }
   }, '#laborerId')
}

$(init)

</script>

<div class='container'>
   <div class='row'>
      <div class='col'>
         <header class='jumbotron p-2'>
            <h1 class='text-center'>HR</h1>
         </header>
      </div>
   </div>
   
   <div class='row'>
      <div class='col'>
         <form>
            <div class='row mb-3'>
               <div class='col-2'>
                  <input type='text' class='form-control' name='laborerName' id='laborerName' placeholder='노동자명'/>
               </div>
               <div class='col-4'>
                  <input type='date' class='form-control' name='hireDate' id='hireDate' placeholder='입사일'/>
               </div>
               <div class='col'>
                  <nav class='d-flex'>
                     <button type='button' class='btn btn-success flex-fill mr-1' id='addLaborerBtn'>
                        <i class='fas fa-plus'></i><span class='label d-none d-md-inline'>추가</span>
                     </button>
                     <button type='button' class='btn btn-info flex-fill mr-1' id='fixLaborerBtn'>
                        <i class='fas fa-edit'></i><span class='label d-none d-md-inline'>수정</span>
                     </button>
                     <button type='button' class='btn btn-warning flex-fill' id='delLaborerBtn'>
                        <i class='fas fa-trash-alt'></i><span class='label d-none d-md-inline'>삭제</span>
                     </button>
                  </nav>
               </div>
            </div>
            
            <div class='row'>
               <div class='col'>
                  <table class='table' id='laborerTable'>
                     <thead><tr><th></th><th>ID</th><th>이름</th><th>입사일</th></tr></thead>
                     <tbody id='laborers'>
                        <tr><td colspan='4' class='text-center'>노동자가 없습니다.</td></tr>
                     </tbody>
                  </table>
               </div>
            </div>
         </form>
      </div>
   </div>
</div>

<div class='modal fade' tabindex='-1' id='modal'>
   <div class='modal-dialog'>
      <div class='modal-content'>
         <div class='modal-header'>
            <button type='button' class='close' data-dismiss='modal'>
               <span>&times;</span>
            </button>
         </div>
         <div class='modal-body'>
            <p id='modalMsg'></p>
         </div>
         <div class='modal-footer' id='modalBtn'>
            <button type='button' class='btn btn-secondary' data-dismiss='modal'>아니오</button>
            <button type='button' class='btn btn-primary' id='delLaborerOkBtn'>예</button>
         </div>
      </div>
   </div>
</div>