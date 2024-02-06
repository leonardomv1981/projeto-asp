$(document).ready(function () {
    
    $("#botaoConsulta").on('click', function(){
        $('#campo_erro').removeClass('bg-warning');
        let data = {acao: $(this).data().acao, currency: $('#currency').val(), proLabore: $('#proLabore').val()};
        $.ajax({
            type: "POST",
            url: `acao.asp`,
            dataType: "",
            data: data,
        })
        .done(function(result) {
            if (result.match('Erro')) {
                console.log('entrou no if')
                $('#campo_erro').addClass('bg-warning');
                $('#campo_erro').html(result);
            } else {
                $('#resultado').html(result);
            }
        });
    });

    $('#currency').maskMoney({
        prefix: "R$: ",
        decimal: ",",
        thousands: "."
    });

    $('#proLabore').maskMoney({
        prefix: "R$: ",
        decimal: ",",
        thousands: "."
    });
    
});