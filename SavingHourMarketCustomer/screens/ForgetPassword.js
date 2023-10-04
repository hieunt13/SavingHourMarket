import {
  StyleSheet,
  Text,
  View,
  TouchableWithoutFeedback,
  Keyboard,
  ImageBackground,
  TextInput,
  TouchableOpacity,
} from 'react-native';
import React, {useState} from 'react';
import FontAwesome from 'react-native-vector-icons/FontAwesome';
import Feather from 'react-native-vector-icons/Feather';
import {COLORS} from '../constants/theme';
import LinearGradient from 'react-native-linear-gradient';
import * as Animatable from 'react-native-animatable';

const ForgetPassword = ({navigation}) => {
  const [email, setEmail] = useState('');
  const [emailError, setEmailError] = useState('');
  const [check_textInputChange, setCheck_textInputChange] = useState(false);

  const emailValidator = () => {
    if (email === '') {
      setEmailError('Email field cannot be empty');
      setCheck_textInputChange(false);
    } else if (!isValidEmail(email)) {
      setEmailError('Invalid email');
      setCheck_textInputChange(false);
    } else {
      setEmailError('');
      setCheck_textInputChange(true);
    }
  };

  const isValidEmail = email => {
    const regex = /^([A-Za-z0-9_\-\.])+@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
    return regex.test(email);
  };
  return (
    <TouchableWithoutFeedback onPress={Keyboard.dismiss} accessible={false}>
      <View style={styles.container}>
        <Animatable.View animation="fadeInLeftBig" style={styles.header}>
          <ImageBackground
            source={require('../assets/image/forgotpassword.png')}
            resizeMode="contain"
            style={{flex: 1, justifyContent: 'center'}}></ImageBackground>
        </Animatable.View>
        <Animatable.View animation="fadeInRightBig" style={styles.footer}>
          <Text style={styles.text_footer}>Forgot Password?</Text>
          <Text style={[styles.text_footer, {fontSize: 18, fontWeight: '700'}]}>
            Please enter your email address below
          </Text>
          <Text style={styles.email_text}>E-MAIL</Text>
          <View style={styles.action}>
            <FontAwesome name="user-o" color={COLORS.primary} size={20} />
            <TextInput
              placeholder="Your email ..."
              style={styles.textInput}
              keyboardType="email-address"
              value={email}
              onBlur={() => {
                emailValidator();
              }}
              onChangeText={text => {
                setEmail(text);
              }}
            />
            {check_textInputChange ? (
              <Animatable.View animation="bounceIn">
                <Feather name="check-circle" color={COLORS.primary} size={20} />
              </Animatable.View>
            ) : null}
          </View>
          {emailError && (
            <View
              style={{
                width: '85%',
                marginTop: '1%',
                marginBottom: '-4%',
              }}>
              <Text style={{color: 'red'}}>{emailError}</Text>
            </View>
          )}
          <View style={styles.button}>
            <TouchableOpacity
              style={{width: '100%'}}
              onPress={() => {
                navigation.navigate('Code reset');
              }}>
              <LinearGradient
                colors={['#66CC66', '#66CC99']}
                style={styles.send}>
                <Text style={[styles.textSign, {color: 'white'}]}>Send</Text>
              </LinearGradient>
            </TouchableOpacity>
          </View>
          <Text
            onPress={() => {
              navigation.navigate('Login');
            }}
            style={{
              fontSize: 16,
              fontFamily: 'Roboto',
              paddingTop: '2%',
              alignSelf: 'center',
            }}>
            Back to login
          </Text>
        </Animatable.View>
      </View>
    </TouchableWithoutFeedback>
  );
};

export default ForgetPassword;

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    flex: 2,
  },
  footer: {
    flex: 3,
    backgroundColor: 'white',
    borderTopLeftRadius: 30,
    borderTopRightRadius: 30,
    paddingHorizontal: 20,
    // paddingVertical: '4%',
  },
  text_footer: {
    color: 'black',
    fontSize: 23,
    alignSelf: 'center',
    fontWeight: 'bold',
    fontFamily: 'Roboto',
    paddingTop: '4%',
  },
  action: {
    flexDirection: 'row',
    marginTop: '3%',
    alignItems: 'center',
    borderBottomWidth: 1,
    borderBottomColor: '#f2f2f2',
    paddingBottom: 2,
    paddingLeft: 5,
  },
  email_text: {
    color: COLORS.primary,
    fontSize: 18,
    fontFamily: 'Roboto',
    paddingTop: '7%',
    paddingLeft: 5,
  },
  textInput: {
    flex: 1,
    paddingLeft: 10,
    color: COLORS.primary,
  },
  button: {
    alignItems: 'center',
    marginTop: '25%',
  },
  send: {
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