import {
  Component,
  EventEmitter,
  Input,
  OnInit,
  Output,
  SimpleChanges,
} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { User } from 'src/app/auth/admin/interfaces/user.interface';
import { UserService } from 'src/app/auth/admin/services/user.service';
import Swal from 'sweetalert2';
import { ValidatorEmailService } from '../../services/validator-email.service';
import { ValidatorUsernameService } from '../../services/validator-username.service';

@Component({
  selector: 'app-profile-form',
  templateUrl: './profile-form.component.html',
  styles: [],
})
export class ProfileFormComponent implements OnInit {
  @Input() editUser!: User;
  oneMegaByte: number = 1048576;
  editImage!: string | null;
  idUser!: number | null;
  title = 'New User';
  imageFile!: File | null;
  isClean = true;
  deleteImage = false;

  alterableUser: User = {
    name: '',
    phone: 0,
    email: '',
    urlImage: '',
    password: '',
    status: '',
  };

  user: FormGroup = this.formBuilder.group(
    {
      name: ['', [Validators.required]],
      username: ['', Validators.required, [this.validatorUsername]],
      phone: [, [Validators.pattern('^[0-9]{10}$')]],
      email: [
        ,
        [
          Validators.required,
          Validators.pattern(this.validatorEmail.emailPattern),
        ],
        [this.validatorEmail],
      ],
      password: [, [Validators.required]],
      confirmPassword: [, [Validators.required]],
    },
    {
      validators: [
        this.validatorEmail.camposIguales('password', 'confirmPassword'),
      ],
    }
  );

  constructor(
    private formBuilder: FormBuilder,
    private userService: UserService,
    private validatorEmail: ValidatorEmailService,
    private validatorUsername: ValidatorUsernameService
  ) {}

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['editUser'].currentValue != null) {
      this.title = 'Edit user';
      this.isClean = false;
      this.idUser = this.editUser.idUser!;
      this.user.get('username')?.setAsyncValidators(null);
      this.user.get('email')?.setAsyncValidators(null);
      this.user.get('password')?.clearValidators();
      this.user.get('password')?.updateValueAndValidity();
      this.user.patchValue(this.editUser!);
      this.editImage = this.editUser.urlImage!;
    }
  }

  timeout: any = null;
  isLoadingEmail: boolean = false;
  isLoadingUsername: boolean = false;
  onKeySearchEmail(event: any) {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      if (event.keyCode != 13) {
        if (this.editUser != null) {
          if (event.target.value !== this.editUser.email) {
            this.isLoadingEmail = true;
            this.user.get('email')?.setErrors({
              whileValidate: true,
            });
            this.validatorEmail
              .validateEmail(event.target.value)
              .subscribe((resp) => {
                this.user.get('email')?.setErrors(resp);
                this.isLoadingEmail = false;
              });
          }
        }
      }
    }, 500);
  }
  onKeySearchUsername(event: any) {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      if (event.keyCode != 13) {
        if (this.editUser != null) {
          if (event.target.value !== this.editUser.username!) {
            this.isLoadingUsername = true;
            this.user.get('username')?.setErrors({
              whileValidate: true,
            });
            this.validatorUsername
              .validateUsername(event.target.value)
              .subscribe((resp) => {
                this.user.get('username')?.setErrors(resp);
                this.isLoadingUsername = false;
              });
          }
        }
      }
    }, 500);
  }

  onFileChange(event: any) {
    this.imageFile = event.target.files[0];
    const fr = new FileReader();
    fr.onload = (event: any) => {
      this.editImage = event.target.result;
    };
    fr.readAsDataURL(this.imageFile!);
    this.imageFile?.name;
  }

  removeImage() {
    this.deleteImage = true;
    this.imageFile = null;
    this.editImage = null;
  }

  ngOnInit(): void {}

  emailText: string = 'This is mandatory.';
  usernameText: string = 'This is mandatory.';
  phoneText = 'This is mandatory.';
  validate(variable: string) {
    if (this.user.controls['phone'].errors != null) {
      if (this.user.controls['phone'].errors!['pattern'] != null) {
        this.phoneText = 'The phone number format is wrong';
      }
      if (this.user.controls['phone'].errors!['required'] != null) {
        this.phoneText = 'This is mandatory.';
      }
    }
    if (this.user.controls['username'].errors != null) {
      if (this.user.controls['username'].errors!['notAvailable'] != null) {
        this.usernameText = 'The username is already in use';
      }
      if (this.user.controls['username'].errors!['required'] != null) {
        this.usernameText = 'This is mandatory.';
      }
    }
    if (this.user.controls['email'].errors != null) {
      if (this.user.controls['email'].errors!['pattern'] != null) {
        this.emailText = 'The email format must be example@gmail.com.';
      }
      if (this.user.controls['email'].errors!['notAvailable'] != null) {
        this.emailText = 'The email is already in use.';
      }
      if (this.user.controls['email'].errors!['required'] != null) {
        this.emailText = 'This is mandatory.';
      }
    }
    return (
      this.user.controls[variable].errors &&
      this.user.controls[variable].touched
    );
  }

  @Output() closeEdit = new EventEmitter<boolean>();
  editUsers() {
    this.alterableUser.name = this.user.value['name'];
    this.alterableUser.username = this.user.value['username'];
    this.alterableUser.phone = this.user.value['phone'];
    this.alterableUser.email = this.user.value['email'];
    if (this.editImage != '') {
      this.alterableUser.urlImage = this.editImage;
    }
    if (this.user.value['password'] == null) {
      this.alterableUser.password = this.editUser.password;
    } else {
      this.alterableUser.password = this.user.value['password'];
    }
    this.alterableUser.status = 'ACTIVE';
    if (this.imageFile == null) {
      Swal.fire({
        title: 'Are you sure you want to edit this user?',
        text: 'You can go back to edit later',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, modify',
        cancelButtonText: 'Cancel',
      }).then((result) => {
        if (result.isConfirmed) {
          this.userService
            .editUsers(this.alterableUser, this.editUser.idUser!, null)
            .subscribe((resp) => {
              this.closeEdit.emit(true);
            });
          Swal.fire(
            'Perfect!',
            'The user was successfully edited!',
            'success'
          );
        }
      });
    } else {
      if (this.imageFile?.size! < this.oneMegaByte) {
        Swal.fire({
          title: 'Are you sure you want to edit this user?',
          text: 'You can go back to edit later',
          icon: 'warning',
          showCancelButton: true,
          confirmButtonColor: '#3085d6',
          cancelButtonColor: '#d33',
          confirmButtonText: 'Yes, modify',
          cancelButtonText: 'Cancel',
        }).then((result) => {
          if (result.isConfirmed) {
            this.userService
              .editUsers(
                this.alterableUser,
                this.editUser.idUser!,
                this.imageFile
              )
              .subscribe(() => {
                this.closeEdit.emit(true);
              });
            Swal.fire(
              'Perfect!',
              'The user was successfully edited!',
              'success'
            );
          }
        });
      } else {
        this.imageFile = null;
        this.editImage = null;
        Swal.fire('Error', 'The image is large.', 'error');
      }
    }
  }

  deleteUser() {
    /*  this.userService.deleteUser(this.editUser.idUser!).subscribe(() => {
      this.userPage.ngOnInit();
      this.clean();
    }); */
  }
}
