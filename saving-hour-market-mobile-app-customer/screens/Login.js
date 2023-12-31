import {
  StyleSheet,
  Text,
  TextInput,
  View,
  TouchableOpacity,
  TouchableWithoutFeedback,
  Keyboard,
  ImageBackground,
  Alert,
} from 'react-native';
import React, {useEffect, useRef, useState, useCallback} from 'react';
import {COLORS} from '../constants/theme';
import FontAwesome from 'react-native-vector-icons/FontAwesome';
import Entypo from 'react-native-vector-icons/Entypo';
import Feather from 'react-native-vector-icons/Feather';
import LinearGradient from 'react-native-linear-gradient';
import * as Animatable from 'react-native-animatable';
import {
  GoogleSignin,
  GoogleSigninButton,
} from '@react-native-google-signin/google-signin';
import auth from '@react-native-firebase/auth';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {API} from '../constants/api';
import {useFocusEffect} from '@react-navigation/native';
import LoadingScreen from '../components/LoadingScreen';
import Toast from 'react-native-toast-message';
import database from '@react-native-firebase/database';

const Login = ({navigation}) => {
  const [password, setPassword] = useState('');
  const [email, setEmail] = useState('');
  const [passwordError, setPasswordError] = useState('');
  const [emailError, setEmailError] = useState('');
  const [secureTextEntry, setSecureTextEntry] = useState(true);
  const [check_textInputChange, setCheck_textInputChange] = useState(false);
  const [initializing, setInitializing] = useState(true);
  const loginMode = useRef('');
  const [loading, setLoading] = useState(false);
  // const [user, setUser] = useState();
  // const [tokenId, setTokenId] = useState('');
  // const [idTokenResultPayload, setIdTokenResultPayload] = useState('');

  // system status check
  useFocusEffect(
    useCallback(() => {
      database().ref(`systemStatus`).off('value');
      database()
        .ref('systemStatus')
        .on('value', async snapshot => {
          if (snapshot.val() === 0) {
            navigation.reset({
              index: 0,
              routes: [{name: 'Initial'}],
            });
          } else {
            // setSystemStatus(snapshot.val());
          }
        });
    }, []),
  );

  const onAuthStateChange = async userInfo => {
    setLoading(true);
    // console.log(userInfo);
    if (initializing) {
      setInitializing(false);
    }
    if (userInfo) {
      // check if user sessions is still available. If yes => redirect to another screen
      console.log(loginMode.current);
      if (loginMode.current.length === 0) {
        const userTokenId = await userInfo
          .getIdToken(true)
          .then(token => token)
          .catch(async e => {
            // sessions end. (revoke refresh token like password change, disable account, ....)
            console.log(e);
            showToast('Vui lòng đăng nhập lại');
            console.log('Session ended. Required re-authenticate');
            await AsyncStorage.removeItem('userInfo');
            setLoading(false);
            return null;
          });
        if (userTokenId) {
          // session van con. redirect qua trang khac
          console.log('User session van con. Redirect qua screen nao do di');
          navigation.navigate('Start');
          setLoading(false);
          return;
        }
        setLoading(false);
        return;
      }
      // login with google
      if (loginMode.current === 'GOOGLE') {
        const userTokenId = await userInfo
          .getIdToken()
          .then(token => token)
          .catch(e => console.log(e));
        const userInfoAfterGooleLoginRequest = await fetch(
          `${API.baseURL}/api/customer/getInfoAfterGoogleLogged`,
          {
            method: 'get',
            headers: {Authorization: `Bearer ${userTokenId}`},
          },
        ).catch(e => {
          setLoading(false);
          console.log(e);
          return null;
        });
        // internal error handle
        if (!userInfoAfterGooleLoginRequest) {
          await logout();
          console.log(
            'internal error happened in fetching user info with google',
          );
          showToast('Lỗi mạng');
          setLoading(false);
          return;
        }
        // staff account access to customer application handle
        if (userInfoAfterGooleLoginRequest.status === 403) {
          const responseBody = await userInfoAfterGooleLoginRequest.json();
          if (responseBody.message === 'STAFF_ACCESS_FORBIDDEN') {
            await logout();
            showToast('Tài khoản của bạn không có quyền truy cập');
            setLoading(false);
            return;
          }
        }
        // fetch success
        if (userInfoAfterGooleLoginRequest.status === 200) {
          const userInfoResult = await userInfoAfterGooleLoginRequest.json();
          // console.log('result: ' + JSON.stringify(userInfoResult));
          // add user info to storage
          await AsyncStorage.setItem(
            'userInfo',
            JSON.stringify(userInfoResult),
          );
          console.log('success');
          // Alert.alert(
          //   'Login thanh cong, da save user. Redirect qua screen nao do di',
          // );
          setLoading(false);
          showToastSuccess('Đăng nhập thành công');
          navigation.reset({
            index: 0,
            routes: [{name: 'Start'}],
          });
        }
      }

      // login with email password
      if (loginMode.current === 'EMAIL_PASSWORD') {
        const userTokenId = await userInfo
          .getIdToken()
          .then(token => token)
          .catch(e => console.log(e));
        const userInfoAfterEmailPasswordLoginRequest = await fetch(
          `${API.baseURL}/api/customer/getInfo`,
          {
            method: 'get',
            credentials: 'include',
            mode: 'no-cors',
            headers: {Authorization: `Bearer ${userTokenId}`},
          },
        ).catch(e => {
          console.log(e);
          setLoading(false);
          return null;
        });

        // internal error handle
        if (!userInfoAfterEmailPasswordLoginRequest) {
          await logout();
          console.log(
            'internal error happened in fetching user info with email & password',
          );
          showToast('Lỗi mạng');
          setLoading(false);
          return;
        }
        // no user found
        if (userInfoAfterEmailPasswordLoginRequest.status === 403) {
          const responseBody =
            await userInfoAfterEmailPasswordLoginRequest.json();
          if (responseBody.message === 'STAFF_ACCESS_FORBIDDEN') {
            await logout();
            showToast('Tài khoản của bạn không có quyền truy cập');
            setLoading(false);
            return;
          }
          if (responseBody.message === 'UNVERIFIED_EMAIL') {
            await logout();
            showToast('Địa chỉ email chưa được xác thực');
            setLoading(false);
            return;
          }
        }

        console.log(userInfoAfterEmailPasswordLoginRequest.status);

        // fetch success
        if (userInfoAfterEmailPasswordLoginRequest.status === 200) {
          const userInfoResult =
            await userInfoAfterEmailPasswordLoginRequest.json();
          // add user info to storage
          await AsyncStorage.setItem(
            'userInfo',
            JSON.stringify(userInfoResult),
          );
          setLoading(false);
          // login thanh cong roi => redirect di dau do di
          // Alert.alert(
          //   'Login thanh cong, da save user. Redirect qua screen nao do di',
          // );
          showToastSuccess('Đăng nhập thành công');
          navigation.reset({
            index: 0,
            routes: [{name: 'Start'}],
          });
        }
      }

      // setTokenId(userTokenId);
      // const userIdTokenPayload = await userInfo
      //   .getIdTokenResult()
      //   .then(payload => payload);
      // setIdTokenResultPayload(userIdTokenPayload);
      console.log('user is logged in');
      setLoading(false);
      // console.log('info login: ' + (await AsyncStorage.getItem('userInfo')));
    } else {
      console.log('user is not logged in');
      setLoading(false);
    }
  };

  const showToast = message => {
    Toast.show({
      type: 'unsuccess',
      text1: 'Thất bại',
      text2: message,
      visibilityTime: 2000,
    });
  };

  const showToastSuccess = message => {
    Toast.show({
      type: 'success',
      text1: 'Thành công',
      text2: message,
      visibilityTime: 2000,
    });
  };

  const login = () => {
    auth()
      .signInWithEmailAndPassword(email, password)
      .then(() => {
        // showToastSuccess('Đăng nhập thành công');
        console.log('User singed in successfully with email and password');
      })
      .catch(error => {
        // handle wrong password or email
        console.log(error.message);
        if (error.message.includes('[auth/user-disabled')) {
          showToast('Tài khoản bị khóa. Vui lòng liên hệ nhân viên');
          return;
        }
        showToast('Sai địa chỉ email hoặc mật khẩu');
      });
  };

  const loginGoogel = async () => {
    await GoogleSignin.hasPlayServices({showPlayServicesUpdateDialog: true});
    const googleSignInResponse = await GoogleSignin.signIn().catch(e => {
      console.log(e);
      return null;
    });

    if (googleSignInResponse) {
      const googleCredential = auth.GoogleAuthProvider.credential(
        googleSignInResponse.idToken,
      );
      return auth()
        .signInWithCredential(googleCredential)
        .then(() => {
          // showToastSuccess('Đăng nhập thành công');
          console.log('User signed in successfully with google account');
        })
        .catch(error => {
          showToast('Đăng nhập thất bại');
          console.log(error);
        });
    }
  };

  const logout = async () => {
    await GoogleSignin.signOut().catch(e => console.log(e));
    await AsyncStorage.removeItem('userInfo').catch(e => console.log(e));
    await auth()
      .signOut()
      .then(() => console.log('Signed out successfully!'))
      .catch(e => console.log(e));
  };

  // useEffect(() => {
  //   console.log(tokenId)
  //   console.log(idTokenResultPayload)
  // }, [setTokenId, setIdTokenResultPayload]);

  useFocusEffect(
    useCallback(() => {
      // auth().currentUser.reload()
      const subscriber = auth().onAuthStateChanged(
        async userInfo => await onAuthStateChange(userInfo),
      );
      GoogleSignin.configure({
        webClientId:
          '857253936194-dmrh0nls647fpqbuou6mte9c7e4o6e6h.apps.googleusercontent.com',
      });
      return subscriber;
      // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []),
  );

  // () => {

  // }, []

  const emailValidator = () => {
    if (email == '') {
      setEmailError('Email không thể rỗng');
      setCheck_textInputChange(false);
      return false;
    } else if (!isValidEmail(email)) {
      setEmailError('Email không hợp lệ!');
      setCheck_textInputChange(false);
      return false;
    } else {
      setEmailError('');
      setCheck_textInputChange(true);
      return true;
    }
  };
  const passwordValidation = () => {
    if (password === '') {
      setPasswordError('Vui lòng điền mật khẩu!');
      return false;
    } else {
      setPasswordError('');
      return true;
    }
  };

  const isValidEmail = email => {
    const regex = /^([A-Za-z0-9_\-\.])+@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
    return regex.test(email);
  };
  const isSecureTextEntry = () => {
    setSecureTextEntry(!secureTextEntry);
  };
  return (
    <TouchableWithoutFeedback onPress={Keyboard.dismiss} accessible={false}>
      <View style={styles.container}>
        <ImageBackground
          source={require('../assets/image/background.jpeg')}
          resizeMode="repeat"
          style={{flex: 1, justifyContent: 'center'}}>
          <Animatable.View animation="fadeInLeft" style={styles.header}>
            <Text style={styles.text_header}>Welcome to </Text>
            <Text style={[styles.text_header, {paddingLeft: 30}]}>
              <FontAwesome name="shopping-basket" color="white" size={30} />{' '}
              Saving Hour Market!
            </Text>
          </Animatable.View>
          <Animatable.View animation="fadeInUpBig" style={styles.footer}>
            <Text style={styles.text_footer}>E-MAIL</Text>
            <View style={styles.action}>
              <FontAwesome name="user-o" color={COLORS.primary} size={20} />
              <TextInput
                placeholder="Your email ..."
                keyboardType="email-address"
                style={styles.textInput}
                onBlur={() => {
                  emailValidator();
                }}
                onChangeText={text => setEmail(text)}
              />
              {check_textInputChange ? (
                <Animatable.View animation="bounceInRight">
                  <Feather
                    name="check-circle"
                    color={COLORS.primary}
                    size={20}
                  />
                </Animatable.View>
              ) : null}
            </View>
            {emailError && (
              <View
                style={{width: '85%', marginTop: '1%', marginBottom: '-4%'}}>
                <Text style={{color: 'red'}}>{emailError}</Text>
              </View>
            )}
            <Text style={[styles.text_footer, {marginTop: 35}]}>Password</Text>
            <View style={styles.action}>
              <Feather name="lock" color={COLORS.primary} size={20} />
              {secureTextEntry ? (
                <TextInput
                  placeholder="Your password ..."
                  onBlur={() => {
                    passwordValidation();
                  }}
                  style={styles.textInput}
                  secureTextEntry={true}
                  value={password}
                  onChangeText={text => setPassword(text)}
                />
              ) : (
                <TextInput
                  placeholder="Your password ..."
                  onBlur={() => {
                    passwordValidation();
                  }}
                  style={styles.textInput}
                  secureTextEntry={false}
                  value={password}
                  onChangeText={text => setPassword(text)}
                />
              )}
              <TouchableOpacity
                onPress={() => {
                  isSecureTextEntry();
                }}>
                {secureTextEntry ? (
                  <Feather name="eye-off" color="grey" size={20} />
                ) : (
                  <Feather name="eye" color="grey" size={20} />
                )}
              </TouchableOpacity>
            </View>
            {passwordError && (
              <View
                style={{width: '85%', marginTop: '1%', marginBottom: '-4%'}}>
                <Text style={{color: 'red'}}>{passwordError}</Text>
              </View>
            )}
            <Text
              onPress={() => {
                navigation.navigate('Forgot password');
              }}
              style={{color: COLORS.secondary, marginTop: 15}}>
              Quên mật khẩu?
            </Text>
            <View style={styles.button}>
              <GoogleSigninButton
                style={[styles.login, {width: '50%'}]}
                size={GoogleSigninButton.Size.Wide}
                color={GoogleSigninButton.Color.Light}
                onPress={() => {
                  loginMode.current = 'GOOGLE';
                  loginGoogel();
                }}
                // disabled={this.state.isSigninInProgress}
              />
              <TouchableOpacity
                style={{width: '100%', marginTop: 15}}
                onPress={() => {
                  if (emailValidator() && passwordValidation()) {
                    loginMode.current = 'EMAIL_PASSWORD';
                    login();
                  } else {
                    return;
                  }
                }}>
                <LinearGradient
                  colors={['#66CC66', '#66CC99']}
                  style={styles.login}>
                  <Text style={[styles.textSign, {color: 'white'}]}>
                    Đăng nhập
                  </Text>
                </LinearGradient>
              </TouchableOpacity>
              <TouchableOpacity
                style={[
                  styles.login,
                  {borderColor: '#66CC66', borderWidth: 1, marginTop: 15},
                ]}
                onPress={() => {
                  navigation.navigate('Sign Up');
                  // logout();
                }}>
                <Text style={[styles.textSign, {color: '#66CC66'}]}>
                  Đăng ký
                </Text>
              </TouchableOpacity>
            </View>
          </Animatable.View>
        </ImageBackground>
        {loading && <LoadingScreen />}
      </View>
    </TouchableWithoutFeedback>
  );
};

export default Login;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.primary,
  },
  header: {
    flex: 1,
    justifyContent: 'flex-end',
    paddingHorizontal: 20,
    paddingBottom: '6%',
  },
  footer: {
    flex: 3,
    backgroundColor: 'white',
    borderTopLeftRadius: 30,
    borderTopRightRadius: 30,
    paddingHorizontal: 20,
    paddingVertical: '4%',
  },
  text_header: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 30,
    fontFamily: 'Roboto',
  },
  text_footer: {
    color: COLORS.primary,
    fontSize: 18,
    fontFamily: 'Roboto',
  },
  action: {
    flexDirection: 'row',
    marginTop: '3%',
    alignItems: 'center',
    borderBottomWidth: 1,
    borderBottomColor: '#f2f2f2',
    paddingBottom: 2,
  },
  textInput: {
    flex: 1,
    paddingLeft: 10,
    color: COLORS.primary,
  },
  button: {
    alignItems: 'center',
    marginTop: '10%',
  },
  login: {
    width: '100%',
    height: 50,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 10,
  },
  textSign: {
    fontSize: 18,
    fontWeight: 'bold',
    fontFamily: 'Roboto',
  },
});
