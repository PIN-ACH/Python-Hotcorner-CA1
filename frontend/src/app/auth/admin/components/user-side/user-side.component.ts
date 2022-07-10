import {
  Component,
  Input,
  OnChanges,
  OnInit,
  SimpleChanges,
} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { delay, map } from 'rxjs';
import { ValidatorEmailService } from 'src/app/auth/shared/services/validator-email.service';
import { ValidatorUsernameService } from 'src/app/auth/shared/services/validator-username.service';
import Swal from 'sweetalert2';
import { User } from '../../interfaces/user.interface';
import { UserComponent } from '../../pages/user/user.component';
import { UserService } from '../../services/user.service';

@Component({
  selector: 'app-user-side',
  templateUrl: './user-side.component.html',
  styles: [],
})
export class UserSideComponent implements OnInit, OnChanges {
  @Input() editUser!: User;
  oneMegaByte: number = 1048576;
  editImage!: string | null;
  imageFile!: File | null;
  isClean = true;
  title: string = 'New User';
  idUser!: number | null;
  alterableUser: User = {
    name: '',
    username: '',
    phone: 0,
    urlImage: '',
    email: '',
    password: '',
    discountPoint: 0,
    status: '',
  };

  user: FormGroup = this.formBuilder.group({
    name: ['', [Validators.required]],
    username: ['', Validators.required, [this.validatorUsername]],
    phone: ['', [Validators.pattern('^[0-9]{10}$')]],
    email: [
      ,
      [
        Validators.required,
        Validators.pattern(this.validatorEmail.emailPattern),
      ],
      [this.validatorEmail],
    ],
    password: [, [Validators.required]],
    discountPoint: [],
    status: ['ACTIVE', [Validators.required]],
  });

  constructor(
    private formBuilder: FormBuilder,
    private userService: UserService,
    private userPage: UserComponent,
    private validatorEmail: ValidatorEmailService,
    private validatorUsername: ValidatorUsernameService
  ) {}

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['editUser'].currentValue != null) {
      this.isClean = false;
      this.idUser = this.editUser.idUser!;
      this.title = 'Edit User';

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
    this.imageFile = null;
    this.editImage = null;
  }

  ngOnInit(): void {}

  clean() {
    this.user.controls['password'].addValidators([
      Validators.required,
      Validators.minLength(6),
    ]);
    this.imageFile = null;
    this.editImage = null;
    this.isClean = true;
    this.user.reset({ status: 'ACTIVE' });
  }

  emailText: string = 'This is mandatory.';
  usernameText: string = 'This is mandatory.';
  phoneText = '';
  validate(variable: string) {
    if (this.user.controls['phone'].errors != null) {
      if (this.user.controls['phone'].errors!['pattern'] != null) {
        this.phoneText = 'The phone number format is wrong.';
      }
    }
    if (this.user.controls['username'].errors != null) {
      if (this.user.controls['username'].errors!['notAvailable'] != null) {
        this.usernameText = 'The username is already in use.';
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

  createUser() {
    if (this.imageFile == null) {
      this.alterableUser = this.user.value;
      this.userService.createUser(this.alterableUser, null).subscribe(() => {
        this.userPage.ngOnInit();
        this.clean();
      });
    } else {
      if (this.imageFile?.size! < this.oneMegaByte) {
        this.alterableUser = this.user.value;
        this.userService
          .createUser(this.alterableUser, this.imageFile)
          .subscribe(() => {
            this.userPage.ngOnInit();
            this.clean();
          });
      } else {
        this.imageFile = null;
        this.editImage = null;
        Swal.fire('Error', 'The image is large.', 'error');
      }
    }
  }

  editUsers() {
    this.alterableUser = this.user.value;
    if (this.editImage != '') {
      this.alterableUser.urlImage = this.editImage;
    }
    if (this.imageFile == null) {
      Swal.fire({
        title: 'Are you sure you want to edit this user?',
        text: 'You can go back to edit later.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, modify!',
        cancelButtonText: 'Cancel',
      }).then((result) => {
        if (result.isConfirmed) {
          this.userService
            .editUsers(this.alterableUser, this.editUser.idUser!, null)
            .subscribe(() => {
              this.userPage.ngOnInit();
              this.clean();
            });
          Swal.fire(
            'Perfect!',
            'The user was successfully edited.',
            'success'
          );
        }
      });
    } else {
      if (this.imageFile?.size! < this.oneMegaByte) {
        Swal.fire({
          title: 'Are you sure you want to edit this user?',
          text: 'You can go back to edit later.',
          icon: 'warning',
          showCancelButton: true,
          confirmButtonColor: '#3085d6',
          cancelButtonColor: '#d33',
          confirmButtonText: 'Yes, modify!',
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
                this.userPage.ngOnInit();
                this.clean();
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
        Swal.fire('Error', 'The image is very heavy.', 'error');
      }
    }
  }

  deleteUser() {
    Swal.fire({
      title: 'Are you sure you want to delete this user?',
      text: 'You will not be able to recover information from it!',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Yes, delete',
      cancelButtonText: 'Cancel',
    }).then((result) => {
      if (result.isConfirmed) {
        this.userService.deleteUser(this.editUser.idUser!).subscribe(() => {
          this.userPage.ngOnInit();
          this.clean();
        });
        Swal.fire('Deleted!', 'The user has been deleted!', 'success');
      }
    });
  }
}
