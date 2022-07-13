const processExec = require("child_process").exec
const ebsOptions = require("./ebs-options.json");

const AWS_REGION = process.env.AWS_REGION || 'sa-east-1'

let args = [...process.argv]
args.shift()
args.shift()
args = args.join(' ')

const exec = command =>
  new Promise((resolve, reject) =>
    processExec(command, (err, stdout, stderr) => (err ? reject(stderr) : resolve(stdout)))
  )

function createDotEnv(){
  const toResolve = ebsOptions.map(row => row.Value).filter(row => row.match(/{{resolve\:(ssm|ssm-secure)\:/)).map(row => row.replace(/((.*resolve:(ssm|ssm-secure):)|(}))/g, ""))

  let chunks = []

  while (toResolve.length > 0) {
    const names = toResolve.splice(0, 10).join(" ")
    chunks.push(names)
  }

  const promises = chunks.map(names => exec(`aws ssm get-parameters --region ${AWS_REGION} --query Parameters --names ${names} ${args}`)
    .then(str => ({args,names, data: JSON.parse(str)})))

  Promise.all(promises)
    .then(result => {
      const unresolvableEnvs = ebsOptions.map(env => `${env.OptionName}=${env.Value}`).filter(row => !row.match(/{{resolve\:(ssm|ssm-secure)\:/))
      const envs = result.map(({ data, names }) => {
        if(data.length === 0) throw new Error(`Nenhuma variável foi retornada opara: ${names}\n\n Verifique usuário e região`)
        return data.map(parameterStore => {
          return `${parameterStore.Name}=${parameterStore.Value}`
        })
      }).reduce((acc, row) => [...acc, ...row], unresolvableEnvs)
      ebsOptions.map(row => row.Value).filter(row => !row.match(/{{resolve\:(ssm|ssm-secure)\:/))
      process.stdout.write(envs.join("\n"))
    })
}

createDotEnv()
