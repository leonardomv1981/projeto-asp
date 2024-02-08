' =============ITEM 5=================
<!-- #include file="connection.asp" -->
<!-- #include file="includes/aspJSON1.19.asp" -->
<%
'=================ITEM 4=================
' Exemplo de tabela para utilização no código (sem guardar os valores fornecidos pelo usuário no banco):
' Tabela "Aliquotairpf"
' id int(11), auto_increment, primary key
' valorInicial decimal(10,2)
' valorFinal decimal(10,2)
' aliquota integer(2)
' deducao decimal(10,2)
' situacao enum('ativo', 'inativo')

' Tabela "Inssprolabore"
' id int(11), auto_increment, primary key
' valorInicial decimal(10,2)
' valorFinal decimal(10,2)
' aliquota integer(2)
' situacao enum('ativo', 'inativo')

' Tabela "Innsfolhapagamento"
' id int(11), auto_increment, primary key
' aliquota integer(2)
' situacao enum('ativo', 'inativo')

' Tabela "Aliquotairpj"
' id int(11), auto_increment, primary key
' aliquota integer(2)
' situacao enum('ativo', 'inativo')

' Importação de arquivo de conexão do DB


'===========ITEM 1================
Function ValidateNumber(value)
    If IsNumeric(value) Then
        if CLng(value) then
            ValidateNumber = CLng(value)
        else
            ValidateNumber = -1
        end if
    Else
        ValidateNumber = False
    End If
End Function

'==============ITEM 2================
Function ValidateText(value)
    ValidateText = Replace(value, "'", "\'")
    ValidateText = Replace(ValidateText, ",", "\,")
    ValidateText = Replace(ValidateText, "-", "\-")
    ValidateText = Replace(ValidateText, ";", "\;")
    ValidateText = Replace(ValidateText, "%", "\%")
End Function

'==================ITEM 8==================
Sub Pause()
    Dim endTime
    endTime = DateAdd("s", 5, Now())
    Do Until Now() >= endTime
    Loop
End Sub

'======================ITEM 9==================================
'inicio do codigo para consumir api com dados ficticios
Dim xmlhttp, result
Set xmlhttp = Server.CreateObject("MSXML2.ServerXMLHTTP")
xmlhttp.Open "GET", "http://187.233.80.10:8081/geracodigo?tipo=xxxxxxxxxxx", False
xmlhttp.Send
result = xmlhttp.responseText
Set xmlhttp = Nothing

'===============ITEM 10===============
set oJSON = New aspJSON
oJSON.loadJSON(result)
response.write(oJSON.data("results")(0)("imagem"))


Dim valor, aliquotaIRPF, aliquotaIRPJ, deducaoIR, valorProLabore, valorINSSEmpresa, valorINSSProLabore, despesas, outrasDespesas

valor = Replace(Request.Form("currency"), "R$: ", "")
valor = Replace(valor, ".", "")
valorProLabore = Replace(Request.Form("proLabore"), "R$: ", "")
valorProLabore = Replace(valorProLabore, ".", "")
outrasDespesas = 500.00
despesas = outrasDespesas

'=====================ITEM 3=====================
'validando valores - garantindo que o conteúdo seja número decimal com ',', inteiro e (proteção contra sql injection) se não for inteiro, a função retornará um -1. Se for inteiro, retornará em formato de longNumber
dim testValor, testProlabore
testValor = ValidateNumber(valor)
testProlabore = ValidateNumber(valorProLabore)
if testValor <> false and testValor <> -1 then
    valor = testValor
elseif testValor = -1 then
    response.write("Erro! O valor não é um inteiro")
    response.end
else 
    response.write("Erro! Valor inválido - o campo deve conter somente números")
    response.end
end if

if testProlabore <> false and testProlabore <> -1 then
    valorProLabore = testProlabore
elseif testProlabore = -1 then
    response.write("Erro! O valor do Pro Labore não é um inteiro")
    response.end
else 
    response.write("Erro! Valor do Pro Labore é inválido - o campo deve conter somente números")
    response.end
end if

'aplicando aliquota de IR da PJ e devolvendo despesa
aliquotaIRPJ = 0.14
despesas = despesas + (valor * aliquotaIRPJ)

'INSS considerando constribuicao do empregado e folha
    valorINSSProLabore = valorProLabore * 0.11
    valorINSSEmpresa = valorProLabore * 0.20

if valorINSSProLabore > 856.46 then
    valorINSSProLabore = 856.46
end if
    despesas = despesas + valorINSSProLabore + valorINSSEmpresa

'calculo do IR
    if (valorProLabore >= 2112.01 And valorProLabore <= 2826.65) then
        aliquotaIRPF = 0.075
        deducaoIR = 158.40
    elseif valorProLabore >= 2826.66 And valorProLabore <= 3751.05 then
        aliquotaIRPF = 0.15
        deducaoIR = 370.40
    elseif valorProLabore >= 3751.06 And valorProLabore <= 4664.68 then
        aliquotaIRPF = 0.225
        deducaoIR = 651.473
    else 
        aliquotaIRPF = 0.275
        deducaoIR = 922.67
    end if

    despesas = despesas + (valorProLabore * aliquotaIRPF) - deducaoIR


'==================ITEM 11==================
dim dateFornecida 
dateFornecida = "08/01/2023 10:01:30"
response.write("+3 anos: " & DateAdd("yyyy", 3, dateFornecida) & "<br>")
response.write("+2 minutos: " & DateAdd("n", 2, dateFornecida) & "<br>")
response.write("Diferenca em dias: " & DateDiff("d", dateFornecida, Now()) & "<br>")
response.write("Diferenca em horas: " & DateDiff("h", dateFornecida, Now()) & "<br>")



'============ITEM 6================
' Inicio do codigo para incluir, atualizar e apagar valores da tabela
' set rs= new adodb.recordset
' findData = rs.open "SELECT * FROM `Aliquotairpf` WHERE Aliquotairpf.situacao = 'ativo'"
' rs.open "INSERT INTO `Aliquotairpf` (valorInicial, valorFinal, aliquota, deducao, situacao) VALUES (0, 2112.00, 0, 0, 'ativo')"
' rs.open "UPDATE `Aliquotaipf` SET valorInicial = 3751.06, valorFinal = 4664.68 WHERE id = " & id
' rs.open "DELETE FROM `Aliquotairpf` WHERE id = " & id

' ================ITEM 7================
' Inicio do código para fazer loop nos valores obtidos no select
' for each data in findData
'     response.write(data("id") & " - " & data("valorInicial") & " - " & data("valorFinal") & " - " & data("aliquota") & " - " & data("deducao") & " - " & data("situacao") & "<br>")
%>

<div class="container text-center">
    <div class="row align-items-start">
        <div class="justify-content-center row">
            <div class="col-6 card" style="padding: 0;">
                <div class="card-header">
                   Resultado:
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        Valor INSS pro labore: R$<%=FormatNumber(valorINSSProLabore, 2)%>
                    </div>
                    <div class="mb-3">
                        Valor INSS empresa: R$<%=FormatNumber(valorINSSEmpresa, 2)%>
                    </div>
                    <div class="mb-3">
                        Valor Imposto da empresa: R$<%=FormatNumber(valor * aliquotaIRPJ, 2)%>
                    </div>
                    <div class="mb-3">
                        Valor total das despesas: R$<%=FormatNumber(despesas, 2)%>
                    </div>
                    <div class="mb-3">
                        Outras despesas (contador, certificado, etc): R$ <%=FormatNumber(outrasDespesas, 2)%>  
                    </div>
                    <div class="mb-3">
                        Valor restante para retirar como lucro: R$<%=FormatNumber(valor - despesas, 2)%>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row" id="resultado" style="margin: 15px">
    </div>
</div>