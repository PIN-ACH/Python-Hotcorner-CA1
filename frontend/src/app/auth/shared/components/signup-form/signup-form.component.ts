import { Component, Input, OnInit } from '@angular/core';
import { FormGroup } from '@angular/forms';

@Component({
  selector: 'app-signup-form',
  templateUrl: './signup-form.component.html',
  styles: [],
})
export class SignupFormComponent implements OnInit {
  @Input() signUpForm!: FormGroup;
  phoneText = 'This is mandatory.';
  emailText = 'This is mandatory.';
  usernameText = 'This is mandatory.';
  password = 'This is mandatory.';
  validate(variable: string) {
    if (this.signUpForm.controls['username'].errors != null) {
      if (
        this.signUpForm.controls['username'].errors!['notAvailable'] != null
      ) {
        this.usernameText = 'The username is already in use.';
      }
      if (this.signUpForm.controls['username'].errors!['required'] != null) {
        this.usernameText = 'This is mandatory.';
      }
    }
    if (this.signUpForm.errors != null) {
      if (this.signUpForm.errors['noIguales'] != null) {
        console.log(123);
        this.password = 'Passwords must be the same.';
      }
    }
    if (this.signUpForm.controls['confirmPassword'].errors != null) {
    }
    if (this.signUpForm.controls['phone'].errors != null) {
      if (this.signUpForm.controls['phone'].errors!['pattern'] != null) {
        this.phoneText = 'The number format is wrong.';
      }
      if (this.signUpForm.controls['phone'].errors!['required'] != null) {
        this.phoneText = 'This is mandatory.';
      }
    }
    if (this.signUpForm.controls['email'].errors != null) {
      if (this.signUpForm.controls['email'].errors!['pattern'] != null) {
        this.emailText = 'The email format must be example@gmail.com.';
      }
      if (this.signUpForm.controls['email'].errors!['required'] != null) {
        this.emailText = 'This is mandatory.';
      }
    }
    return (
      this.signUpForm.controls[variable].errors &&
      this.signUpForm.controls[variable].touched
    );
  }

  constructor() {}

  ngOnInit(): void {}
}
