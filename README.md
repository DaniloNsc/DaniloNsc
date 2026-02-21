# RAM Optimizer Windows

Automação em **PowerShell** para executar o **RAMMap** (Microsoft Sysinternals) em intervalo configurável, facilitando a rotina de monitoramento/gestão de memória no Windows.

---

## 📌 1) Visão geral

Este projeto contém um script PowerShell pronto para uso com:
- Validação do caminho do executável do RAMMap
- Execução em loop contínuo
- Intervalo customizável
- Modo de execução única (`-RunOnce`)
- Logs simples no console
- Proteção contra múltiplas instâncias simultâneas do RAMMap

---

## 🧱 2) Estrutura do projeto

```txt
ram-optimizer-windows/
├── script.ps1   # Script principal
└── README.md    # Documentação técnica
```

---

## ⚙️ 3) Funcionamento interno

Fluxo do `script.ps1`:
1. Recebe parâmetros (`-RamMapPath`, `-IntervalSeconds`, `-RunOnce`)
2. Normaliza o caminho e valida se o executável existe
3. Verifica se já existe instância do RAMMap em execução
4. Executa o RAMMap com `Start-Process` (somente se não houver instância ativa)
5. Se `-RunOnce` estiver ativo, encerra
6. Caso contrário, aguarda e repete

### Parâmetros
- `-RamMapPath` (string): caminho do `RAMMap.exe`
- `-IntervalSeconds` (int): intervalo entre execuções (mínimo: 5s)
- `-RunOnce` (switch): executa uma vez e encerra

---

## ▶️ 4) Como executar

### Pré-requisitos
- Windows 10/11
- PowerShell 5+
- RAMMap instalado

### Execução padrão (loop a cada 5 minutos)
```powershell
powershell -ExecutionPolicy Bypass -File .\script.ps1
```

### Execução com caminho customizado e intervalo de 2 minutos
```powershell
powershell -ExecutionPolicy Bypass -File .\script.ps1 -RamMapPath "C:\Tools\RAMMap\RAMMap.exe" -IntervalSeconds 120
```

### Execução única
```powershell
powershell -ExecutionPolicy Bypass -File .\script.ps1 -RunOnce
```

---

## 🔐 5) Segurança

Este projeto **não altera** registro do Windows, serviços do sistema ou arquivos críticos.

---

## 🚀 6) Como criar um repositório separado só para este projeto

Se hoje o código está em um repositório geral/perfil, faça assim:

1. Crie um novo repositório no GitHub (exemplo: `ram-optimizer-windows`).
2. No computador local, mantenha apenas os arquivos deste projeto (`script.ps1` e `README.md`) em uma pasta própria.
3. Rode os comandos abaixo dentro da pasta do projeto:

```bash
git init
git add .
git commit -m "feat: initial RAM Optimizer Windows project"
git branch -M main
git remote add origin https://github.com/<seu-usuario>/ram-optimizer-windows.git
git push -u origin main
```

4. Pronto: projeto isolado, documentação técnica e histórico próprio.

---

## 📄 Licença

Uso educacional e demonstração técnica.
