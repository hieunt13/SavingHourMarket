import {
  View,
  Text,
  Image,
  TextInput,
  Pressable,
  Platform,
  Button,
  KeyboardAvoidingView,
  TouchableWithoutFeedback,
  Keyboard,
  Alert,
} from 'react-native';
import {
  GoogleSignin,
  GoogleSigninButton,
} from '@react-native-google-signin/google-signin';
import React, { useState, useEffect, useCallback } from 'react';
import { format } from 'date-fns';
import { SafeAreaView } from 'react-native-safe-area-context';
import Ionicons from 'react-native-vector-icons/Ionicons';
import { TouchableOpacity } from 'react-native-gesture-handler';
import { ScrollView } from 'react-native-gesture-handler';
import AntDesign from 'react-native-vector-icons/AntDesign';
import DateTimePicker from '@react-native-community/datetimepicker';
import FlatButton from '../shared/button';
import { useFocusEffect } from '@react-navigation/native';
import auth from '@react-native-firebase/auth';
import * as ImagePicker from 'react-native-image-picker';
import storage from '@react-native-firebase/storage';
import * as Progress from 'react-native-progress';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { API } from '../constants/api';
import LoadingScreen from '../components/LoadingScreen';
import database from '@react-native-firebase/database';

const EditProfile = ({ navigation, route }) => {
  const user = route.params.user;
  // console.log(user);
  const [username, setUsername] = useState(user?.fullName);
  const [address, setAddress] = useState(user?.address);
  const [phone, setPhone] = useState(user?.phone);
  const [email, setEmail] = useState(user?.email);
  const [dateOfBirth, setDateOfBirth] = useState(user?.dateOfBirth);
  const [usernameError, setUsernameError] = useState('');
  const [addressError, setAddressError] = useState('');
  const [phoneError, setPhoneError] = useState('');
  const [emailError, setEmailError] = useState('');
  const [dateOfBirthError, setDateOfBirthError] = useState('');
  const [date, setDate] = useState(new Date());
  const [showPicker, setShowPicker] = useState(false);
  const [display, setDisplay] = useState(false);

  const [initializing, setInitializing] = useState(true);
  const [image, setImage] = useState(null);
  const [uploading, setUploading] = useState(false);
  const [transferred, setTransferred] = useState(0);
  const [loading, setLoading] = useState(false);

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
              routes: [{ name: 'Initial' }],
            });
          } else {
            // setSystemStatus(snapshot.val());
          }
        });
    }, []),
  );

  const selectImage = () => {
    const options = {
      maxWidth: 2000,
      maxHeight: 2000,
      storageOptions: {
        skipBackup: true,
        path: 'images',
      },
    };
    ImagePicker.launchImageLibrary(options).then(response => {
      if (response.didCancel) {
        console.log('User cancelled image picker');
      } else if (response.error) {
        console.log('ImagePicker Error: ', response.error);
      } else if (response.customButton) {
        console.log('User tapped custom button: ', response.customButton);
      } else {
        const source = response.assets[0].uri;
        console.log('hinh anh', source);
        setImage(source);
      }
    });
  };

  const uploadImage = async () => {
    const uri = image;
    const filename = uri.substring(uri.lastIndexOf('/') + 1);
    const uploadUri = Platform.OS === 'ios' ? uri.replace('file://', '') : uri;
    setUploading(true);
    setTransferred(0);

    let url;

    const task = storage().ref(`userImage/${filename}`).putFile(uploadUri);

    // set progress state
    task.on('state_changed', snapshot => {
      setTransferred(
        Math.round(snapshot.bytesTransferred / snapshot.totalBytes) * 10000,
      );
    });
    try {
      await task;
      url = await storage().ref(`userImage/${filename}`).getDownloadURL();
      // console.log(url);
    } catch (e) {
      console.log(e);
    }
    setUploading(false);
    // Alert.alert(
    //   'Photo uploaded!',
    //   'Your photo has been uploaded to Firebase Cloud Storage!',
    // );
    setImage(null);
    return url;
  };

  //authen check
  const onAuthStateChange = async userInfo => {
    // console.log(userInfo);
    if (initializing) {
      setInitializing(false);
    }
    if (userInfo) {
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
        await AsyncStorage.removeItem('userInfo');
        return;
      }

      console.log('user is logged in');
      console.log('userInfo', await AsyncStorage.getItem('userInfo'));
    } else {
      // no sessions found.
      console.log('user is not logged in');
    }
  };

  useEffect(() => {
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
  }, []);

  const toggleDatepicker = () => {
    setShowPicker(!showPicker);
  };
  const onChange = ({ type }, selectedDate) => {
    if (type == 'set') {
      const currentDate = selectedDate;
      setDate(currentDate);
      if (Platform.OS === 'android') {
        toggleDatepicker();
        setDateOfBirth(currentDate);
      }
    } else {
      toggleDatepicker();
    }
  };
  const formatDate = rawDate => {
    let date = new Date(rawDate);
    let year = date.getFullYear();
    let month = date.getMonth() + 1;
    let day = date.getDate();

    return `${day}/${month}/${year}`;
  };
  const isValidPhone = phone => {
    const regex =
      /^(0|84)(2(0[3-9]|1[0-6|8|9]|2[0-2|5-9]|3[2-9]|4[0-9]|5[1|2|4-9]|6[0-3|9]|7[0-7]|8[0-9]|9[0-4|6|7|9])|3[2-9]|5[5|6|8|9]|7[0|6-9]|8[0-6|8|9]|9[0-4|6-9])([0-9]{7})$/;
    return regex.test(phone);
  };

  const isValidName = name => {
    const regex = /^[A-Za-zÀ-ỹ ]{2,50}$/;
    return regex.test(name);
  };
  const isValidForm = () => {
    setUsernameError('');
    setDateOfBirthError('');
    setEmailError('');
    setAddressError('');
    setPhoneError('');
    if (username === null || username.trim().length == 0) {
      return setUsernameError('Vui lòng không bỏ trống !');
    }
    if (!isValidName(username)) {
      return setUsernameError('Username không hợp lệ!');
    }
    if (dateOfBirth === null) {
      return setDateOfBirthError('Date of birth can not be empty !');
    }
    if (email.trim().length == 0) {
      return setEmailError('Vui lòng không bỏ trống !');
    }
    // if (!isValidEmail(email)) {
    //   return setEmailError('Email không hợp lệ !');
    // }
    // if (address === null || address.trim().length == 0) {
    //   return setAddressError('Address can not be empty !');
    // }
    if (phone === null || !isValidPhone(phone)) {
      return setPhoneError('Số điện thoại không hợp lệ!');
    }
    return true;
  };

  const submitForm = async () => {
    setLoading(true);
    console.log(phone);
    let submitInfo = {};
    if (!isValidForm()) {
      setLoading(false);
      return;
    }
    const valid = isValidForm();
    if (valid === true) {
      let avatarUrl;
      if (image !== null) {
        avatarUrl = await uploadImage();
      } else {
        avatarUrl = user?.avatarUrl;
      }

      submitInfo = {
        fullName: username,
        phone: phone,
        dateOfBirth: dateOfBirth
          ? format(new Date(dateOfBirth), 'yyyy-MM-dd')
          : user?.dateOfBirth,
        address: address,
        gender: 0,
        avatarUrl: avatarUrl ? avatarUrl : user?.avatarUrl,
      };
      console.log('Info', submitInfo);
      const token = await auth().currentUser.getIdToken();
      console.log('token: ', token);
      fetch(`${API.baseURL}/api/customer/updateInfo`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(submitInfo),
      })
        .then(res => {
          return res.json();
        })
        .then(async respond => {
          console.log('respone', JSON.stringify(respond));
          if (respond.code === 422) {
            console.log('loi sdt');
            Alert.alert(respond.message);
            setLoading(false);
            return;
          }
          await AsyncStorage.setItem('userInfo', JSON.stringify(respond));
          setLoading(false);
          navigation.navigate('Profile');
        })
        .catch(err => {
          console.log('Lỗi', err);
          setLoading(false);
        });
    }
  };

  return (
    <TouchableWithoutFeedback onPress={Keyboard.dismiss} accessible={false}>
      <SafeAreaView style={{ backgroundColor: 'white', height: '100%' }}>
        <View
          style={{
            marginHorizontal: '5%',
            marginTop: '4%',
            flexDirection: 'row',
          }}>
          <TouchableOpacity
            onPress={() => {
              navigation.goBack();
            }}>
            <Ionicons
              style={{ top: '10%' }}
              name="arrow-back-sharp"
              size={28}
              color="black"></Ionicons>
          </TouchableOpacity>
          <Text
            style={{
              paddingLeft: 14,
              fontSize: 25,
              fontWeight: 'bold',
              color: 'black',
              fontFamily: 'Roboto',
            }}>
            Chỉnh sửa thông tin
          </Text>
        </View>
        <View
          style={{
            marginVertical: '6%',
            paddingHorizontal: 20,
          }}>
          <TouchableOpacity onPress={selectImage}>
            {image !== null ? (
              <Image
                source={{ uri: image }}
                style={{
                  width: 120,
                  height: 120,
                  alignSelf: 'center',
                  borderRadius: 100,
                }}
              />
            ) : (
              <Image
                style={{
                  width: 120,
                  height: 120,
                  alignSelf: 'center',
                  borderRadius: 100,
                }}
                source={{ uri: `${user?.avatarUrl}` }}
              />
            )}
          </TouchableOpacity>
        </View>
        {/* Form */}
        <KeyboardAvoidingView
          enabled
          style={{ flex: 1, marginBottom: 10 }}
          behavior={Platform.OS === 'ios' ? 'padding' : null}>
          <ScrollView
            showsVerticalScrollIndicator={false}
            style={{ flexDirection: 'column' }}
            contentContainerStyle={{
              justifyContent: 'space-between',
              flexGrow: 1,
            }}>
            <View
              style={{
                flexDirection: 'column',
                rowGap: 2,
                alignItems: 'center',
              }}>
              <TextInput
                style={[
                  {
                    height: 40,
                    width: '90%',
                    backgroundColor: '#e5e5e5',
                    margin: 12,
                    borderRadius: 20,
                    padding: 10,
                  },
                  usernameError ? { borderColor: 'red', borderWidth: 1 } : {},
                ]}
                onChangeText={setUsername}
                placeholder="User Name"
                value={username}
                keyboardType="default"></TextInput>
              {usernameError && (
                <View style={{ width: '85%', marginTop: '-4%' }}>
                  <Text style={{ color: 'red' }}>{usernameError}</Text>
                </View>
              )}
              <View
                style={[
                  {
                    backgroundColor: '#e5e5e5',
                    height: 40,
                    width: '90%',
                    borderRadius: 20,
                    margin: 12,
                    paddingHorizontal: 8,
                  },
                  dateOfBirthError ? { borderColor: 'red', borderWidth: 1 } : {},
                ]}>
                {showPicker && (
                  <DateTimePicker
                    mode="date"
                    display="spinner"
                    value={date}
                    onChange={onChange}
                    maximumDate={new Date()}
                  />
                )}
                <Pressable
                  style={{
                    flexDirection: 'row',
                    justifyContent: 'center',
                    alignItems: 'center',
                  }}
                  onPress={toggleDatepicker}>
                  <TextInput
                    style={{ flex: 1, color: 'black' }}
                    onChangeText={setDateOfBirth}
                    value={
                      dateOfBirth
                        ? format(new Date(dateOfBirth), 'dd/MM/yyyy')
                        : ''
                    }
                    underlineColorAndroid="transparent"
                    placeholder="Ngày tháng năm sinh"
                    keyboardType="default"
                    editable={false}></TextInput>
                  <AntDesign
                    name="calendar"
                    size={25}
                    color="black"></AntDesign>
                </Pressable>
              </View>
              {dateOfBirthError && (
                <View style={{ width: '85%', marginTop: '-4%' }}>
                  <Text style={{ color: 'red' }}>{dateOfBirthError}</Text>
                </View>
              )}
              <TextInput
                style={[
                  {
                    height: 40,
                    margin: 12,
                    width: '90%',
                    backgroundColor: '#e5e5e5',
                    borderRadius: 20,
                    padding: 10,
                  },
                  emailError ? { borderColor: 'red', borderWidth: 1 } : {},
                ]}
                onChangeText={text => {
                  setEmail(text);
                }}
                value={email}
                editable={false}
                placeholder="Email"
                keyboardType="email-address"></TextInput>
              {emailError && (
                <View style={{ width: '85%', marginTop: '-4%' }}>
                  <Text style={{ color: 'red' }}>{emailError}</Text>
                </View>
              )}
              <TextInput
                style={[
                  {
                    height: 40,
                    margin: 12,
                    width: '90%',
                    backgroundColor: '#e5e5e5',
                    borderRadius: 20,
                    padding: 10,
                  },
                  addressError ? { borderColor: 'red', borderWidth: 1 } : {},
                ]}
                onChangeText={text => {
                  setAddress(text);
                }}
                value={address}
                placeholder="Địa chỉ"
                keyboardType="default"></TextInput>
              {addressError && (
                <View style={{ width: '85%', marginTop: '-4%' }}>
                  <Text style={{ color: 'red' }}>{addressError}</Text>
                </View>
              )}
              <TextInput
                style={[
                  {
                    height: 40,
                    margin: 12,
                    width: '90%',
                    backgroundColor: '#e5e5e5',
                    borderRadius: 20,
                    padding: 10,
                  },
                  phoneError ? { borderColor: 'red', borderWidth: 1 } : {},
                ]}
                onChangeText={text => {
                  setPhone(text);
                }}
                value={phone}
                placeholder="Số điện thoại"
                keyboardType="numeric"></TextInput>
              {phoneError && (
                <View style={{ width: '85%', marginTop: '-4%' }}>
                  <Text style={{ color: 'red' }}>{phoneError}</Text>
                </View>
              )}
            </View>
            <View
              style={{
                flexDirection: 'column',
                alignItems: 'center',
                marginBottom: '4%',
              }}>
              <View style={{ width: '90%' }}>
                <FlatButton text="Cập nhật" onPress={submitForm} />
              </View>
            </View>
          </ScrollView>
        </KeyboardAvoidingView>
        {loading && <LoadingScreen />}
      </SafeAreaView>
    </TouchableWithoutFeedback>
  );
};

export default EditProfile;
