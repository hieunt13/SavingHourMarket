/* eslint-disable prettier/prettier */
import {
  View,
  Text,
  Alert,
  TouchableWithoutFeedback,
  Keyboard,
  StyleSheet,
  ImageBackground,
  Dimensions,
} from 'react-native';
import React, {useState, useEffect, useRef, useCallback} from 'react';
import {TextInput, TouchableOpacity} from 'react-native-gesture-handler';
import auth from '@react-native-firebase/auth';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {API} from '../constants/api';
import LinearGradient from 'react-native-linear-gradient';
import * as Animatable from 'react-native-animatable';
import FontAwesome from 'react-native-vector-icons/FontAwesome';
import Feather from 'react-native-vector-icons/Feather';
import {COLORS} from '../constants/theme';
import LoadingScreen from '../components/LoadingScreen';
import Toast from 'react-native-toast-message';
import database from '@react-native-firebase/database';
import {useFocusEffect} from '@react-navigation/native';

const Login = ({navigation}) => {
  // listen to system state
  useFocusEffect(
    useCallback(() => {
      database().ref(`systemStatus`).off('value');
      database()
        .ref(`systemStatus`)
        .on(
          'value',
          async snapshot => {
            console.log('System status: ', snapshot.val());
            if (snapshot.val() === 0) {
              if (auth().currentUser) {
                await auth().signOut();
              }
              navigation.reset({
                index: 0,
                routes: [{name: 'Start'}],
              });
              setLoading(false);
            }
          },
          error => {
            console.error(error);
          },
        );
      // return () => database().ref(`systemStatus`).off('value', onSystemStateChange);
    }, [navigation]),
  );

  const [password, setPassword] = useState('');
  const [email, setEmail] = useState('');
  const [passwordError, setPasswordError] = useState('');
  const [emailError, setEmailError] = useState('');
  const [secureTextEntry, setSecureTextEntry] = useState(true);
  const [check_textInputChange, setCheck_textInputChange] = useState(false);
  const [initializing, setInitializing] = useState(true);
  const loginMode = useRef('');
  const [loading, setLoading] = useState(false);

  const onAuthStateChange = async userInfo => {
    // console.log(userInfo);
    if (initializing) {
      setInitializing(false);
    }
    if (userInfo) {
      console.log('a');
      // check if user sessions is still available. If yes => redirect to another screen
      const userTokenId = await userInfo
        .getIdToken(true)
        .then(token => token)
        .catch(async e => {
          console.log(e);
          return null;
        });
      if (!userTokenId) {
        // sessions end. (revoke refresh token like password change, disable account, ....)
        return;
      }
      const currentUser = await AsyncStorage.getItem('userInfo');
      if (currentUser) {
        navigation.navigate('Tabs');
      }
    } else {
      // no sessions found.
    }
  };

  useEffect(() => {
    const subscriber = auth().onAuthStateChanged(
      async userInfo => await onAuthStateChange(userInfo),
    );
    return subscriber;
  }, []);

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
    setLoading(true);
    auth()
      .signInWithEmailAndPassword(email, password)
      .then(async () => {
        const tokenId = await auth().currentUser.getIdToken();
        fetch(`${API.baseURL}/api/staff/getInfo`, {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${tokenId}`,
          },
        })
          .then(async res => {
            if (res.status === 403 || res.status === 401) {
              const tokenIdCheck = await auth()
                .currentUser.getIdToken(true)
                .catch(async err => {
                  await AsyncStorage.setItem('isDisableAccount', '1');
                  return null;
                });
              if (!tokenIdCheck) {
                throw new Error();
              }
              // Cac loi 403 khac thi handle duoi day neu co
            }
            return res.json();
          })
          .then(async respond => {
            // handle customer account
            if (respond.code === 403) {
              auth()
                .signOut()
                .then(async () => {
                  // Sign-out successful
                  showToast('Tài khoản của bạn không có quyền truy cập');
                  setLoading(false);
                  await AsyncStorage.removeItem('userInfo');
                })
                .catch(error => {
                  // An error happened.
                });
              return;
            }
            // * *

            // handle orther role account
            if (
              !(
                respond.role === 'STAFF_ORD' ||
                respond.role === 'STAFF_DLV_1' ||
                respond.role === 'STAFF_DLV_0'
              )
            ) {
              auth()
                .signOut()
                .then(async () => {
                  // Sign-out successful.
                  showToast('Tài khoản của bạn không có quyền truy cập');
                  setLoading(false);
                  await AsyncStorage.removeItem('userInfo');
                })
                .catch(error => {
                  // An error happened.
                });

              return;
            }
            // * *

            // login successfull
            setLoading(false);
            showToastSuccess('Đăng nhập thành công');
            await AsyncStorage.setItem('userInfo', JSON.stringify(respond));
            navigation.navigate('Tabs');
            // **
          })

          .catch(err => {
            console.log(err);
          });
      })
      .catch(error => {
        // handle wrong password or email
        setLoading(false);
        console.log(error);
        if (error.message.includes('[auth/user-disabled')) {
          showToast('Tài khoản bị khóa. Vui lòng liên hệ nhân viên');
          return;
        }
        showToast('Sai địa chỉ email hoặc mật khẩu');
      });
  };

  const emailValidator = () => {
    if (email == '') {
      setEmailError('Vui lòng nhập email');
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
                value={email}
                onBlur={() => {
                  emailValidator();
                }}
                onChangeText={e => setEmail(e)}
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
                  onChangeText={e => setPassword(e)}
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
            {/* <Text
              onPress={() => {
                navigation.navigate('Forgot password');
              }}
              style={{color: COLORS.secondary, marginTop: 15}}>
              Forgot password?
            </Text> */}
            <View style={styles.button}>
              <TouchableOpacity
                style={{marginTop: 15, width: 300}}
                onPress={() => {
                  if (emailValidator() && passwordValidation()) {
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
              {/* <TouchableOpacity
                style={[
                  styles.login,
                  {borderColor: '#66CC66', borderWidth: 1, marginTop: 15},
                ]}
                onPress={() => {
                  navigation.navigate('Sign Up');
                  // logout();
                }}>
                <Text style={[styles.textSign, {color: '#66CC66'}]}>
                  Sign Up
                </Text>
              </TouchableOpacity> */}
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
    marginTop: '20%',
    // width: '100%',
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
