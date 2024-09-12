import { cpf as validator } from 'cpf-cnpj-validator';

export class CPF {
  readonly value: string;

  constructor(cpf: string) {
    if (!validator.isValid(cpf)) {
      throw new Error(`${cpf} is not a valid cpf`);
    }
    this.value = cpf.replace(/\D/g, '');
  }
}
