<%
Dim valor, aliquotaIRPF, aliquotaIRPJ, deducaoIR, valorProLabore, valorINSSEmpresa, valorINSSProLabore, despesas, outrasDespesas

valor = Replace(Request.Form("currency"), "R$: ", "")
valor = Replace(valor, ".", "")
valorProLabore = Replace(Request.Form("proLabore"), "R$: ", "")
valorProLabore = Replace(valorProLabore, ".", "")
outrasDespesas = 500.00
despesas = outrasDespesas


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